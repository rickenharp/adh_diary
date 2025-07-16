module AdhDiary
  class WithingsMapper < Dry::Transformer::Pipe
    MEASUREMENT_TYPES = {
      weight: 1,
      diastolic: 9,
      systolic: 10
    }.freeze

    import Dry::Transformer::ArrayTransformations
    import Dry::Transformer::HashTransformations

    define! do
      deep_symbolize_keys
      extract_measurement_groups
      ungroup :measures, [:value, :type, :unit]
      map_array do |v|
        real_value
        accept_keys MEASUREMENT_TYPES.keys
      end
      merge_blood_pressure
      merge_into_hash
      accept_keys [:weight, :blood_pressure]
    end

    def real_value(data)
      data.tap do
        new_value = (it[:value] * 10**it[:unit]).round(2).to_f
        new_key = MEASUREMENT_TYPES.key(it[:type])
        it[new_key] = new_value
      end
    end

    def extract_measurement_groups(data)
      data.dig(:body, :measuregrps)
    end

    def merge_blood_pressure(data)
      data.tap do
        blood_pressure = [
          find_and_extract(data, :systolic),
          find_and_extract(data, :diastolic)
        ].join("/")
        data << {blood_pressure: blood_pressure}
      end
    end

    def merge_into_hash(data)
      {}.merge(*data)
    end

    private

    def find_and_extract(hash, key)
      hash.find { it.has_key? key }[key].to_i
    end
  end
end

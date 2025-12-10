# auto_register: false

module AdhDiary
  module Views
    module Parts
      class Entry < AdhDiary::Views::Part
        def formatted_weight
          value.weight.nil? ? "-" : value.weight
        end

        def formatted_blood_pressure
          value.blood_pressure.nil? ? "-" : value.blood_pressure
        end
      end
    end
  end
end

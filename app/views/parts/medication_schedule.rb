# auto_register: false
# frozen_string_literal: true

module AdhDiary
  module Views
    module Parts
      class MedicationSchedule < AdhDiary::Views::Part
        def long_name
          "#{value.medication.name} #{value.morning.to_i}-#{value.noon.to_i}-#{value.evening.to_i}-#{value.before_bed.to_i}"
        end
      end
    end
  end
end

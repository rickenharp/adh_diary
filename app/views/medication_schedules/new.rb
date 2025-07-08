# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module MedicationSchedules
      class New < AdhDiary::View
        expose :medication_schedule do
          OpenStruct.new(
            medication_id: nil,
            morning: 0,
            noon: 0,
            evening: 0,
            before_bed: 0
          )
        end

        expose(:form, as: Parts::Forms::MedicationSchedule) do |medication_schedule, values: {}, errors: {}|
          {
            medication_schedule: medication_schedule,
            values: values,
            errors: errors
          }
        end
      end
    end
  end
end

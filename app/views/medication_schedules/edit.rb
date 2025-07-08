# frozen_string_literal: true

module AdhDiary
  module Views
    module MedicationSchedules
      class Edit < AdhDiary::View
        include Deps["repos.medication_schedule_repo"]

        expose :medication_schedule do |id:|
          medication_schedule_repo.get(id)
        end

        expose(:form, as: Parts::Forms::MedicationSchedule) do |medication_schedule, values: {}, errors: {}|
          {
            medication_schedule: medication_schedule,
            values: {},
            errors: errors
          }
        end
      end
    end
  end
end

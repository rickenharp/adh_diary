# frozen_string_literal: true

module AdhDiary
  module Views
    module MedicationSchedules
      class Delete < AdhDiary::View
        include Deps["repos.medication_schedule_repo"]

        expose :medication_schedule do |id:|
          medication_schedule_repo.get(id)
        end
      end
    end
  end
end

# frozen_string_literal: true

require "ostruct"
module AdhDiary
  module Views
    module MedicationSchedules
      class Index < AdhDiary::View
        include Deps["repos.medication_schedule_repo"]

        expose :medication_schedules do
          medication_schedule_repo.all
        end
      end
    end
  end
end

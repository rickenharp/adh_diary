# frozen_string_literal: true

module AdhDiary
  module Actions
    module MedicationSchedules
      class Destroy < AdhDiary::Action
        include Deps["routes", "repos.medication_schedule_repo"]

        params do
          required(:action).filled(:string)
          required(:id).filled(:integer)
        end

        def handle(request, response)
          if request.params[:action] == "confirm"
            response.flash[:notice] = "Medication schedule deleted"
            medication_schedule_repo.delete(request.params[:id])
          else
            response.flash[:notice] = "Medication schedule not deleted"
          end
          response.redirect_to routes.path(:medication_schedules)
        end
      end
    end
  end
end

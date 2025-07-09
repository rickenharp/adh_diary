# frozen_string_literal: true

module AdhDiary
  module Actions
    module MedicationSchedules
      class Create < AdhDiary::AuthenticatedAction
        include Deps["repos.medication_schedule_repo", "routes"]

        params do
          required(:medication_schedule).hash do
            required(:medication_id).filled(:integer)
            required(:morning).filled(:float)
            required(:noon).filled(:float)
            required(:evening).filled(:float)
            required(:before_bed).filled(:float)
            optional(:notes).maybe(:string)
          end
        end

        def handle(request, response)
          if request.params.valid?
            medication_schedule_repo.create(request.params[:medication_schedule].to_h)
            response.flash[:notice] = "Medication schedule was successfully created"
            response.redirect routes.path("medication_schedules")
          else
            response.flash.now[:alert] = "Could not create medication schedule"
            errors = request.params.errors[:medication_schedule].to_h

            response.render(
              view,
              values: request.params[:medication_schedule].to_h,
              errors: errors
            )
          end
        end
      end
    end
  end
end

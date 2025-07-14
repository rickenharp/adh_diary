# frozen_string_literal: true

module AdhDiary
  module Actions
    module MedicationSchedules
      class Create < AdhDiary::AuthenticatedAction
        include Deps["repos.medication_schedule_repo"]

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
            response.flash[:notice] = response.flash[:notice] = flash_message(success: true)
            response.redirect routes.path("medication_schedules")
          else
            response.flash.now[:alert] = response.flash[:notice] = response.flash[:notice] = flash_message(success: false)
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

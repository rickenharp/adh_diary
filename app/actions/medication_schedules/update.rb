# frozen_string_literal: true

module AdhDiary
  module Actions
    module MedicationSchedules
      class Update < AdhDiary::Authenticated
        include Deps["repos.medication_schedule_repo"]

        params do
          required(:id).filled(:integer)
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
            medication_schedule_repo.update(request.params[:id], request.params[:medication_schedule])
            request.flash[:notice] = flash_message(success: true)
            response.redirect "/medication_schedules"
          else
            request.flash.now[:alert] = flash_message(success: false)
            errors = request.params.errors[:medication_schedule].to_h

            response.render(
              view,
              values: request.params[:medication_schedule],
              id: request.params[:id],
              errors: errors
            )
          end
        end
      end
    end
  end
end

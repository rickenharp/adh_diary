# frozen_string_literal: true

module AdhDiary
  module Actions
    module Medications
      class Create < AdhDiary::AuthenticatedAction
        include Deps["repos.medication_repo"]

        params do
          required(:medication).hash do
            required(:name).filled(:string)
          end
        end

        def handle(request, response)
          if request.params.valid?
            medication_repo.create(request.params[:medication].to_h)
            response.flash[:notice] = flash_message(success: true)
            response.redirect routes.path("medications")
          else
            response.flash.now[:alert] = flash_message(success: false)
            errors = request.params.errors[:medication].to_h

            response.render(
              view,
              values: request.params[:medication],
              errors: errors
            )
          end
        end
      end
    end
  end
end

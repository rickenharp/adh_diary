# frozen_string_literal: true

module AdhDiary
  module Actions
    module Medications
      class Update < AdhDiary::AuthenticatedAction
        include Deps["repos.medication_repo"]

        params do
          required(:id).filled(:integer)
          required(:medication).hash do
            required(:name).filled(:string)
          end
        end

        def handle(request, response)
          if request.params.valid?
            medication_repo.update(request.params[:id], request.params[:medication])
            request.flash[:notice] = flash_message(success: true)
            response.redirect "/medications"
          else
            request.flash.now[:alert] = flash_message(success: false)
            errors = request.params.errors[:medication].to_h
            response.render(
              view,
              values: request.params[:medication],
              id: request.params[:id],
              errors: errors
            )
          end
        end
      end
    end
  end
end

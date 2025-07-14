# frozen_string_literal: true

module AdhDiary
  module Actions
    module Medications
      class Destroy < AdhDiary::AuthenticatedAction
        include Deps["repos.medication_repo"]

        before :validate_params

        params do
          required(:action).filled(:string)
          required(:id).filled(:integer)
        end

        def handle(request, response)
          if request.params[:action] == "confirm"
            response.flash[:notice] = flash_message(success: true)
            medication_repo.delete(request.params[:id])
          else
            response.flash[:notice] = flash_message(success: false)
          end
          response.redirect_to routes.path(:medications)
        end

        private

        def validate_params(request, response)
          halt 422, request.params.errors.to_h unless request.params.valid?
        end
      end
    end
  end
end

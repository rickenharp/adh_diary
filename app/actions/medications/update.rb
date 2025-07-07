# frozen_string_literal: true

module AdhDiary
  module Actions
    module Medications
      class Update < AdhDiary::Action
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
            request.flash[:notice] = "Medication successfully updated"
            response.redirect "/medications"
          else
            request.flash.now[:alert] = "Could not update medication"
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

# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Create < AdhDiary::AuthenticatedAction
        include Deps["repos.entry_repo", "entries.create"]

        def handle(request, response)
          case create.call(request.params, request.session[:user_id])
          in Success(entry)
            request.session[:last_medication] = request.params[:entry][:medication]
            request.session[:last_dose] = request.params[:entry][:dose]
            response.flash[:notice] = "Entry created"
            response.redirect_to routes.path(:entries, id: entry[:id])
          in Failure(validation)
            response.flash.now[:alert] = "Could not create entry"
            errors = validation.errors[:entry].to_h

            response.render(
              view,
              values: request.params[:entry],
              errors:
            )
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Update < AdhDiary::AuthenticatedAction
        include Deps["repos.entry_repo", "entries.update"]

        def handle(request, response)
          case update.call(request.params)
          in Success(entry)
            request.session[:last_medication] = request.params[:entry][:medication]
            request.session[:last_dose] = request.params[:entry][:dose]
            response.flash[:notice] = "Entry updated"
            response.redirect_to routes.path(:entries, id: entry[:id])
          in Failure(validation)
            response.flash.now[:alert] = "Could not update entry"
            errors = validation.errors[:entry].to_h

            response.render(
              view,
              values: request.params[:entry],
              id: request.params[:id],
              errors:
            )
          end
        end
      end
    end
  end
end

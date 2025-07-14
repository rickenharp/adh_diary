# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Update < AdhDiary::AuthenticatedAction
        include Deps["repos.entry_repo", "entries.update"]

        def handle(request, response)
          case update.call(request.params)
          in Success(entry)
            response.flash[:notice] = flash_message(success: true)
            response.redirect_to routes.path(:entries, id: entry[:id])
          in Failure(validation)
            response.flash.now[:alert] = flash_message(success: false)
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

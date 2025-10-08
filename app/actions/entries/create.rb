# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Create < AdhDiary::Authenticated
        include Deps["repos.entry_repo", "entries.create"]

        def handle(request, response)
          case create.call(request.params)
          in Success(entry)
            response.flash[:notice] = flash_message(success: true)
            response.redirect_to routes.path(:entries)
          in Failure(validation)
            response.flash.now[:alert] = flash_message(success: false)
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

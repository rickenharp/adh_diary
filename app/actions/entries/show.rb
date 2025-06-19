# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Show < AdhDiary::AuthenticatedAction
        def handle(request, response)
          response.render(view, id: request.params[:id])
        end
      end
    end
  end
end

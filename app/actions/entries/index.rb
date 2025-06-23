# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Index < AdhDiary::AuthenticatedAction
        def handle(request, response)
          response.render(
            view,
            selected_id: request.params[:id].to_i,
            user_id: request.session[:user_id],
            page: (request.params[:page] || 1).to_i
          )
        end
      end
    end
  end
end

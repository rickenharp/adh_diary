# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class Index < AdhDiary::AuthenticatedAction
        def handle(request, response)
          response.render view, selected_id: request.params[:id].to_i, user_id: request.session[:user_id]
        end
      end
    end
  end
end

# frozen_string_literal: true

module AdhDiary
  module Actions
    module Auth
      class DeveloperCallback < AdhDiary::Action
        def handle(request, response)
          user_info = request.env["omniauth.auth"]
          request.session[:user_id] = user_info.id
        end
      end
    end
  end
end

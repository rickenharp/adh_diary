# frozen_string_literal: true

# auto_register: false

require "hanami/action"
require "dry/monads"

module AdhDiary
  class AuthenticatedAction < AdhDiary::Action
    before :authenticate_user

    private

    def authenticate_user(request, response)
      response.redirect_to("/login") unless request.env["warden"].user
    end
  end
end

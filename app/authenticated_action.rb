# frozen_string_literal: true

# auto_register: false

require "hanami/action"
require "dry/monads"
require "dry-effects"

module AdhDiary
  class AuthenticatedAction < AdhDiary::Action
    include Dry::Effects::Handler.Reader(:user)

    before :authenticate_user

    def call(env)
      with_user(env["warden"].user) do
        super
      end
    end

    private

    def authenticate_user(request, response)
      response.redirect_to("/login") unless request.env["warden"].user
    end
  end
end

# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module AdhDiary
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]
    include Dry::Effects::Handler.Reader(:user)
    include Deps["i18n"]

    # handle_exception ROM::TupleCountMismatchError => :handle_not_found
    before :set_locale

    def call(env)
      with_user(env["warden"].user) do
        super
      end
    end

    private

    def set_locale(request, response)
      i18n.locale = request.session[:language] || i18n.default_locale
    end

    def handle_not_found(request, response, exception)
      response.status = 404
      response.format = :html
      response.body = "Not found"
    end
  end
end

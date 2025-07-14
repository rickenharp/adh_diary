# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module AdhDiary
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]
    include Dry::Effects::Handler.Reader(:user)
    include Deps["i18n", "inflector"]

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

    def flash_message(success:)
      action = inflector.demodulize(self.class.name).downcase
      item = self.class.name
        .then { it.split("::") }
        .then { it[-2] }
        .then { inflector.underscore(it) }
        .then { inflector.singularize(it) }
        .then { it.downcase }
      key = success ? "general.successful_#{action}" : "general.not_#{action}"
      item_key = "general.#{item}"
      i18n.t(key, item: i18n.t(item_key)).capitalize
    end
  end
end

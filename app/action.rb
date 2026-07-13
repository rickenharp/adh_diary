# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"
require "dry/effects"

module AdhDiary
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]
    include Deps["i18n", "inflector", "repos.account_repo"]

    before :set_locale

    private

    def set_locale(request, response)
      Hanami.app["i18n"].locale = request.session[:language] || Hanami.app["i18n"].default_locale
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

# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module AdhDiary
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]
    include Dry::Effects::Handler.Reader(:account)
    include Dry::Effects::Reader(:account)
    include Deps["i18n", "inflector", "sentry"]

    handle_exception StandardError => :handle_standard_error
    before :set_locale

    def handle(request, response)
      with_account(request.env["warden"].user) do
        super
      end
    end

    def callback_phase # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      error = request.params["error_reason"] || request.params["error"]
      if !options.provider_ignores_state && (request.params["state"].to_s.empty? || request.params["state"] != session.delete("omniauth.state"))
        fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
      elsif error
        fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
      else
        self.access_token = build_access_token
        self.access_token = access_token.refresh! if access_token.expired?
        super
      end
    rescue ::OAuth2::Error, CallbackError => e
      fail!(:invalid_credentials, e)
    rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
      fail!(:timeout, e)
    rescue ::SocketError => e
      fail!(:failed_to_connect, e)
    end

    private

    def handle_standard_error(request, response, exception)
      if Hanami.env?(:development, :test)
        raise exception
      else
        sentry.capture_exception(exception)

        response.status = 500
        response.body = "Sorry, something went wrong handling your request"
      end
    end

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

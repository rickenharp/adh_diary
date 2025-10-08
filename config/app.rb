# frozen_string_literal: true

require "hanami"
require "omniauth"

require "rack/unpoly/middleware"
require "omniauth/strategies/withings"

begin
  require "amazing_print"
  require "pry"
rescue LoadError
  # Just ignore this outside of development and test
end

module AdhDiary
  class App < Hanami::App
    def self.oauth2_connection_options
      if settings.oauth_debug && Hanami.env == :development
        {
          proxy: "http://localhost:9090",
          ssl: {verify: false}
        }
      else
        {}
      end
    end

    if settings.oauth_debug
      Hanami.app.config.logger.level = :debug
    end

    config.render_errors = false

    if settings.base_url
      OmniAuth.config.full_host = settings.base_url
      Hanami.app.config.base_url = settings.base_url
    end

    Dry::Validation.load_extensions(:monads)
    config.actions.sessions = :cookie, {
      key: "adh_diary.session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365
    }
    config.actions.content_security_policy[:script_src] = [
      "'self'",
      "'unsafe-inline'"
    ].join(" ")
    config.actions.content_security_policy[:connect_src] = [
      "'self'"
    ].join(" ")
    config.actions.content_security_policy[:form_action] = [
      "https://account.withings.com/",
      "'self'"
    ].join(" ")
    config.actions.content_security_policy[:font_src] = [
      "'self'",
      "https://cdnjs.cloudflare.com",
      "https://fonts.gstatic.com",
      "data:"
    ].join(" ")

    # OmniAuth::AuthenticityTokenProtection.default_options(key: "_csrf_token", authenticity_param: "_csrf_token")

    withings_options = [
      settings.withings_client_id, settings.withings_client_secret,
      {
        scope: "user.info,user.metrics,user.activity",
        authorize_options: %i[scope state mode],
        # client_options: {
        #   connection_opts: oauth2_connection_options
        # },
        token_params: {
          action: "requesttoken",
          client_id: settings.withings_client_id,
          client_secret: settings.withings_client_secret
        }
      }
    ]

    config.middleware.use OmniAuth::Builder do
      provider :developer
      provider :withings, *withings_options
    end

    # config.middleware.use Rack::Unpoly::Middleware
    # config.middleware.use AccountDryEffect
  end
end

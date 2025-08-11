# frozen_string_literal: true

require "hanami"
require "warden"
require "omniauth"
require "user_dry_effect"
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

    if settings.host_name
      OmniAuth.config.full_host = "https://#{settings.host_name}"
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

    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app =
        lambda do |env|
          AdhDiary::Actions::AuthFailure::Show.new.call(env)
        end
    end

    # OmniAuth::AuthenticityTokenProtection.default_options(key: "_csrf_token", authenticity_param: "_csrf_token")

    withings_options = [
      Hanami.app.settings.withings_client_id, Hanami.app.settings.withings_client_secret,
      {
        scope: "user.info,user.metrics,user.activity",
        authorize_options: %i[scope state mode],
        client_options: {
          connection_opts: oauth2_connection_options
        },
        token_params: {
          action: "requesttoken",
          client_id: settings.withings_client_id,
          client_secret: settings.withings_client_secret
        }
      }
    ]

    config.middleware.use OmniAuth::Builder do
      provider :developer
      # provider :withings,
      #   ENV["WITHINGS_CLIENT_ID"], ENV["WITHINGS_CLIENT_SECRET"],
      #   mode: "demo",
      #   scope: "user.info,user.metrics,user.activity",
      #   state: "FOOOBAR",
      #   authorize_options: %i[scope state mode]
      provider :withings,
        # Hanami.app.settings.withings_client_id, Hanami.app.settings.withings_client_secret,
        # mode: "demo",
        *withings_options
    end

    config.middleware.use Rack::Unpoly::Middleware
    config.middleware.use UserDryEffect
  end
end

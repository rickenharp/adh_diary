# frozen_string_literal: true

require "hanami"
require "warden"
require "omniauth"
# require "omniauth-oauth2-generic"
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
      environment(:development) do
        if settings.oauth_debug
          {
            proxy: "http://localhost:9090",
            ssl: {verify: false}
          }
        else
          {}
        end
      end
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
    config.actions.content_security_policy[:font_src] = [
      "'self'",
      "https://cdnjs.cloudflare.com",
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
        # request_path: "http://adh-diary.daho.im:2300/auth/withings/callback",
        client_options: {connection_opts: oauth2_connection_options},
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
  end
end

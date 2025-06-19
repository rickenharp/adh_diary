# frozen_string_literal: true

require "hanami"
require "warden"

module AdhDiary
  class App < Hanami::App
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
  end
end

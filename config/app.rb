# frozen_string_literal: true

require "hanami"
require "omniauth"
# require "rack/csrf"

# OmniAuth::AuthenticityTokenProtection.default_options(authenticity_param: "_csrf_token")

module AdhDiary
  class App < Hanami::App
    config.middleware.use OmniAuth::Strategies::Developer
    config.actions.sessions = :cookie, {
      key: "adh_diary.session",
      secret: settings.session_secret,
      expire_after: 60 * 60 * 24 * 365
    }
    config.actions.content_security_policy[:script_src] = [
      "'self'",
      "https://kit.fontawesome.com",
      "localhost:2300",
      "localhost:2323",
      "'unsafe-inline'"
    ].join(" ")
    config.actions.content_security_policy[:connect_src] = [
      "'self'",
      "https://ka-f.fontawesome.com"
    ].join(" ")
    config.actions.content_security_policy[:font_src] = [
      "'self'",
      "https://ka-f.fontawesome.com",
      "https://cdnjs.cloudflare.com",
      "data:"
    ].join(" ")
  end
end

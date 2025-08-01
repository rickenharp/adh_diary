# frozen_string_literal: true

require "sentry-ruby"

use Sentry::Rack::CaptureExceptions

require "hanami/boot"

OmniAuth.config.logger = Hanami.app["logger"]
OmniAuth.config.request_validation_phase = AdhDiary::Action.new
run Hanami.app

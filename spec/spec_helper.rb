# frozen_string_literal: true

require "dry-effects"

SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"
require "hanami/prepare"

require "dry/system/stubs"
Hanami.app.container.enable_stubs!

SPEC_ROOT.glob("support/**/*.rb").each { |f| require f }

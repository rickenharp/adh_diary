# frozen_string_literal: true

require "dry-effects"

require "pathname"
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"
require "hanami/prepare"

require "dry/system/stubs"
Hanami.app.container.enable_stubs!

require "i18n/missing_translations"
module I18n
  class MyExceptionHandler < ExceptionHandler
    def call(exception, locale, key, options)
      if MissingTranslation === exception
        # ap(exception:, locale: locale, key: key, options: options)
        I18n.missing_translations.log(exception.keys)
      else
        pp exception
      end
      super
    end
  end
end

I18n.exception_handler = I18n::MyExceptionHandler.new

at_exit { Hanami.app[:i18n].missing_translations.dump }

SPEC_ROOT.glob("support/**/*.rb").each { |f| require f }

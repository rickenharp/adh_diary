# auto_register: false

module AdhDiary
  module Views
    class Context < Hanami::View::Context
      include Deps["i18n"]

      def t(...)
        i18n.translate(...)
      end

      def languages
        I18n.available_locales
      end

      def languages_for_select
        languages.each_with_object({}) { |lang, hash| hash[t(lang)] = lang }
      end

      def current_language
        i18n.locale
      end

      def warden
        request.env["warden"]
      end
    end
  end
end

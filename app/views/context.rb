# auto_register: false

module AdhDiary
  module Views
    class Context < Hanami::View::Context
      include Deps["i18n"]
      include Dry::Effects::Reader(:user)

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

      def current_user
        user
      end
    end
  end
end

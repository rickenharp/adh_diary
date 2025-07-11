# frozen_string_literal: true

module AdhDiary
  module Actions
    module Language
      class Update < AdhDiary::AuthenticatedAction
        include Dry::Effects.Reader(:user)
        include Deps["repos.user_repo", "i18n"]

        contract Language::UpdateContract

        def handle(request, response)
          referer = if request.referer
            URI.parse(request.referer)
          else
            URI::HTTP.build(path: "/")
          end

          if request.params.valid?
            lang = request.params[:lang]
            user_repo.update_locale(lang)
            i18n.locale = lang
          else
            response.flash[:alert] = I18n.t("could_not_change_language")
          end
          response.redirect referer.request_uri
        end
      end
    end
  end
end

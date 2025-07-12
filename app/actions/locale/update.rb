# frozen_string_literal: true

module AdhDiary
  module Actions
    module Locale
      class Update < AdhDiary::Action
        include Dry::Effects.Reader(:user)
        include Deps["repos.user_repo", "i18n"]

        contract Locale::UpdateContract

        def handle(request, response)
          referer = if request.referer
            URI.parse(request.referer)
          else
            URI::HTTP.build(path: "/")
          end

          if request.params.valid?
            language = request.params[:language]
            response.session[:language] = language
            user_repo.update_locale(language) if user
          else
            response.flash[:alert] = I18n.t("could_not_change_locale")
          end
          response.redirect referer.request_uri
        end
      end
    end
  end
end

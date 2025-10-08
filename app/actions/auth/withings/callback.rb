# frozen_string_literal: true

module AdhDiary
  module Actions
    module Auth
      module Withings
        class Callback < AdhDiary::Authenticated
          include Deps["repos.identity_repo"]

          def handle(request, response)
            identity_repo.upsert(
              account_id: account.id,
              provider: "withings",
              token: request.env["omniauth.auth"]["credentials"]["token"],
              refresh_token: request.env["omniauth.auth"]["credentials"]["refresh_token"],
              expires_at: Time.at(request.env["omniauth.auth"]["credentials"]["expires_at"], in: "UTC"),
              uid: request.env["omniauth.auth"]["uid"]
            )
            response.flash[:notice] = "Successfully connected to Withings"
            response.redirect "/"
          end
        end
      end
    end
  end
end

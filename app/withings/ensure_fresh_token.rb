# frozen_string_literal: true

require "faraday"

module AdhDiary
  module Withings
    class EnsureFreshToken
      include Dry::Monads[:result]
      include Deps["repos.identity_repo"]

      def call(access_token:, user:)
        if access_token.expired?
          fresh_token = access_token.refresh
          identity_repo.upsert(
            user_id: user.id,
            provider: "withings",
            token: fresh_token.token,
            refresh_token: fresh_token.refresh_token,
            expires_at: Time.at(fresh_token.expires_at, in: "UTC")
          )
        else
          fresh_token = access_token
        end
        if (token = fresh_token.token)
          Success(token)
        else
          Failure(:no_token)
        end
      end
    end
  end
end

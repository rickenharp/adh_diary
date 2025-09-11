# frozen_string_literal: true

module AdhDiary
  module Structs
    class User < AdhDiary::DB::Struct
      # include Deps["oauth2_client"]
      def access_token_for(provider)
        oauth2_client = Hanami.app["oauth2_client"]
        identity = identities.find { it.provider == "withings" }
        return nil if identity.nil?

        WithingsAccessToken.from_hash(oauth2_client, {body: identity.to_h})
      end
    end
  end
end

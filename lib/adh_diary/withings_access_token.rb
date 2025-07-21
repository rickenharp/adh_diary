require "oauth2/access_token"
module AdhDiary
  class WithingsAccessToken < OAuth2::AccessToken
    class << self
      def from_hash(client, hash)
        super(client, hash[:body])
      end
    end

    def refresh(params = {}, access_token_opts = {}, &block)
      additional_params = {
        action: "requesttoken",
        client_id: Hanami.app.settings.withings_client_id,
        client_secret: Hanami.app.settings.withings_client_secret
      }
      super(params.merge(additional_params), access_token_opts, &block)
    end

    def get(path, opts = {action: "get"}, &block)
      request(:get, path, opts, &block)
    end
  end
end

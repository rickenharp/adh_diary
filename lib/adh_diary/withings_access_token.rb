require "oauth2/access_token"

module AdhDiary
  class WithingsAccessToken < OAuth2::AccessToken
    class << self
      def from_hash(client, hash)
        super(client, hash[:body])
      end
    end

    def expired?
      expires? && (expires_at <= Hanami.app["now"].call.to_i)
    end

    def refresh(params = {}, access_token_opts = {}, &block)
      settings = AdhDiary::App["settings"]
      additional_params = {
        action: "requesttoken",
        client_id: settings.withings_client_id,
        client_secret: settings.withings_client_secret
      }
      super(params.merge(additional_params), access_token_opts, &block)
    end

    def get(path, opts = {action: "get"}, &block)
      request(:get, path, opts, &block)
    end
  end
end

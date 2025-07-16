require "oauth2/access_token"
module AdhDiary
  class WithingsAccessToken < OAuth2::AccessToken
    class << self
      def from_hash(client, hash)
        super(client, hash[:body]).tap { ap it }
      end

      def get(path, opts = {action: "get"}, &block)
        request(:get, path, opts, &block)
      end
    end
  end
end

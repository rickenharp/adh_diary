require "omniauth-oauth2"
require "adh_diary/withings_access_token"

module OmniAuth
  module Strategies
    class Withings < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "withings"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      # https://account.withings.com/oauth2_user/authorize2?response_type=code&client_id=YOUR_CLIENT_ID&scope=user.info,user.metrics,user.activity&redirect_uri=YOUR_REDIRECT_URI&state=YOUR_STATE
      option :client_options, {
        site: "https://account.withings.com/", # including port if necessary
        user_info_url: "https://wbsapi.withings.net/v2/user",
        authorize_url: "oauth2_user/authorize2",
        token_url: "https://wbsapi.withings.net/v2/oauth2/",
        access_token_class: AdhDiary::WithingsAccessToken
      }

      # You may specify that your strategy should use PKCE by setting
      # the pkce option to true: https://tools.ietf.org/html/rfc7636
      # option :pkce, true

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { access_token["userid"] }

      # info do
      #   {
      #     name: raw_info["name"],
      #     email: raw_info["email"]
      #   }
      # end

      # extra do
      #   {
      #     "raw_info" => raw_info
      #   }
      # end

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {redirect_uri: callback_url.split("?").first}.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
      end

      def raw_info
        @raw_info = {}
      end
    end
  end
end

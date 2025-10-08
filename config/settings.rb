# frozen_string_literal: true

module AdhDiary
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool
    setting :session_secret, constructor: Types::String
    setting :withings_client_id, constructor: Types::String
    setting :withings_client_secret, constructor: Types::String
    setting :oauth_debug, default: false, constructor: Types::Params::Bool
    setting :base_url, default: nil, constructor: Types::String.optional
    setting :smtp_port, default: 25, constructor: Types::Params::Integer.optional
    setting :smtp_host, default: nil, constructor: Types::String.optional
    setting :smtp_domain, default: nil, constructor: Types::String.optional
    setting :smtp_user_name, default: nil, constructor: Types::String.optional
    setting :smtp_password, default: nil, constructor: Types::String.optional
    setting :deployment, default: Hanami.env.to_s, constructor: Types::String
  end
end

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
    setting :host_name, default: nil, constructor: Types::String.optional
  end
end

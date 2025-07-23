# frozen_string_literal: true

require "faraday"
require "gitlab-chronic"

module AdhDiary
  module Withings
    class GetMeasurements < AdhDiary::Operation
      include Deps["withings.get_token", "withings.ensure_fresh_token", "withings.get_data_from_withings", "withings.mapper"]

      def call(user)
        access_token = step get_token.call(user: user)
        token = step ensure_fresh_token.call(access_token: access_token, user: user)
        data = step get_data_from_withings.call(token: token)
        mapper.call(data)
      end
    end
  end
end

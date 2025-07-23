# frozen_string_literal: true

require "faraday"
require "gitlab-chronic"

module AdhDiary
  module Withings
    class GetDataFromWithings
      include Dry::Monads[:result]
      include Deps["withings_conn"]

      def call(token:)
        resp = withings_conn.post("/measure") do |req|
          req.headers["Authorization"] = "Bearer #{token}"
        end
        if resp.success?
          json = JSON.parse(resp.body)
          if json["status"] == 0
            Success(json)
          else
            Failure(json["error"])
          end
        else
          Failure(:api_request_failed)
        end
      end
    end
  end
end

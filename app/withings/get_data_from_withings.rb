# frozen_string_literal: true

require "faraday"

module AdhDiary
  module Withings
    class GetDataFromWithings
      include Dry::Monads[:result]
      include Deps["withings_conn", "now"]

      def call(token:)
        resp = withings_conn.post("/measure") do |req|
          req.params[:startdate] = startdate(now.call.utc).to_i
          req.params[:enddate] = enddate(now.call.utc).to_i
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

      def startdate(time)
        Time.utc(time.year, time.month, time.day)
      end

      def enddate(time)
        Time.utc(time.year, time.month, time.day, 23, 59)
      end
    end
  end
end

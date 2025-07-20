# frozen_string_literal: true

require "faraday"
require "gitlab-chronic"

module AdhDiary
  module Withings
    class GetMeasurements < AdhDiary::Operation
      include Deps["repos.user_repo"]

      def call(user)
        access_token = user.access_token_for("withings")
        if access_token.expired?
          access_token.refresh!
          user_repo.changeset(:update, user.id, access_token: access_token.token).commit
        end
        token = access_token.token
        conn = Faraday.new(
          url: "https://wbsapi.withings.net/",
          params: {
            action: "getmeas",
            meastypes: WithingsMapper::MEASUREMENT_TYPES.values.map(&:to_s).join(","),
            category: 1,
            startdate: Chronic.parse("yesterday at midnight").to_i,
            enddate: (Chronic.parse("today at midnight") - 1).to_i
          },
          headers: {"Authorization" => "Bearer #{token}"}
        )

        resp = conn.post("/measure")

        data = JSON.parse(resp.body)
        WithingsMapper.new.call(data)
      end
    end
  end
end

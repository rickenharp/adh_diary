# frozen_string_literal: true

require "faraday"
require "gitlab-chronic"

module AdhDiary
  module Withings
    class GetMeasurements < AdhDiary::Operation
      include Deps["repos.identity_repo"]

      def call(user)
        access_token = step get_token(user)
        token = step ensure_fresh_token(access_token, user)
        data = step get_data_from_withings(token)
        WithingsMapper.new.call(data)
      end

      def get_data_from_withings(token)
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

      def get_token(user)
        if (access_token = user.access_token_for("withings"))
          Success(access_token)
        else
          Failure(:no_token)
        end
      end

      def ensure_fresh_token(access_token, user)
        if access_token.expired?
          fresh_token = access_token.refresh
          identity_repo.upsert(fresh_token)
          identity_repo.upsert(
            user_id: user.id,
            provider: "withings",
            token: access_token.token,
            refresh_token: access_token.refresh_token,
            expires_at: access_token.expires_at
          )
        else
          fresh_token = access_token
        end
        if (token = fresh_token.token)
          Success(token)
        else
          Failure(:no_token)
        end
      end

      def parse_json(json)
        Success(JSON.parse(json))
      end
    end
  end
end

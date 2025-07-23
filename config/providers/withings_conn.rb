Hanami.app.register_provider(:withings_conn) do
  prepare do
    require "faraday"
    require "gitlab-chronic"
  end

  start do
    conn = Faraday.new(
      url: "https://wbsapi.withings.net/",
      params: {
        action: "getmeas",
        meastypes: AdhDiary::Withings::MEASUREMENT_TYPES.values.map(&:to_s).join(","),
        category: 1,
        startdate: Chronic.parse("yesterday at midnight", now: target[:time]).to_i,
        enddate: (Chronic.parse("today at midnight", now: target[:time]) - 1).to_i
      }
    )

    register :withings_conn, conn
  end
end

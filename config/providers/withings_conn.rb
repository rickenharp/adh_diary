Hanami.app.register_provider(:withings_conn) do
  prepare do
    require "faraday"
  end

  start do
    conn = Faraday.new(
      url: "https://wbsapi.withings.net/",
      params: {
        action: "getmeas",
        meastypes: AdhDiary::Withings::MEASUREMENT_TYPES.values.map(&:to_s).join(","),
        category: 1
      }
    )

    register :withings_conn, conn
  end
end

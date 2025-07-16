Hanami.app.register_provider(:oauth2_client) do
  # prepare do
  # end

  start do
    client = OmniAuth::Strategies::Withings.new(target).client
    register :oauth2_client, client, call: false
  end
end

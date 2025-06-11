Hanami.app.register_provider(:omniauth) do
  prepare do
    require "omniauth"
  end

  start do
    OmniAuth.config.request_validation_phase = AdhDiary::Action.new

    # register "email_client", client
  end
end

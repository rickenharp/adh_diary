Hanami.app.register_provider(:sentry) do
  prepare do
    require "sentry-ruby"
  end

  start do
    Sentry.init do |config|
      config.dsn = "https://aad06dfa59b142a4994b4ebc3da83754@bugsink.rickenharp.cloud/1"
      config.breadcrumbs_logger = [:sentry_logger, :http_logger]
      # Add data like request headers and IP for users, if applicable;
      # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
      config.send_default_pii = true
      config.environment = Hanami.env.to_s
      config.enabled_environments = %w[production staging]
    end

    register :sentry, Sentry
  end
end

Hanami.app.register_provider :mail do
  prepare do
    require "mail"
  end

  start do
    smtp_config = {
      address: target["settings"].smtp_host,
      port: target["settings"].smtp_port,
      domain: target["settings"].smtp_domain,
      user_name: target["settings"].smtp_user_name,
      password: target["settings"].smtp_password,
      enable_starttls_auto: true,
      ssl: true,
      authentication: :login
    }.compact
    Mail.defaults do
      if Hanami.env == :test
        # Deliver to Mail::TestMailer.deliveries
        delivery_method :test
      else
        delivery_method :smtp, smtp_config
      end
    end
  end
end

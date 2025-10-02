require "dry/effects"

class AccountDryEffect
  include Dry::Effects::Handler.Reader(:account)

  def initialize(app)
    @app = app
  end

  def call(env)
    with_account(detect_account(env)) do
      @app.call(env)
    end
  end

  def detect_account(env)
    env["warden"].user
  end
end

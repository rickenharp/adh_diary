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
    if env["rodauth"].logged_in?
      _account = env["rodauth"].account_from_session

      Hanami.app["repos.account_repo"].by_id(env["rodauth"].account_id)
    end
  end
end

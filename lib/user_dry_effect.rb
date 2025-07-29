require "dry/effects"

class UserDryEffect
  include Dry::Effects::Handler.Reader(:user)

  def initialize(app)
    @app = app
  end

  def call(env)
    with_user(detect_user(env)) do
      @app.call(env)
    end
  end

  def detect_user(env)
    env["warden"].user
  end
end

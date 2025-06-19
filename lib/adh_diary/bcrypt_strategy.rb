require "warden/strategies/base"
require "bcrypt"

module AdhDiary
  class BcryptStrategy < Warden::Strategies::Base
    include Deps["repos.user_repo"]
    def valid?
      params["email"] || params["password"]
    end

    def authenticate!
      user = user_repo.by_email(params["email"])

      if user && user.password_hash == BCrypt::Engine.hash_secret(request.params["password"], user.password_salt)
        return success!(user)
      end
      fail!("Could not log in")
    end
  end
end

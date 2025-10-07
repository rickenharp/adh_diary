require "warden/strategies/base"
require "bcrypt"

module AdhDiary
  class BcryptStrategy < Warden::Strategies::Base
    include Deps["repos.account_repo"]

    def valid?
      params["email"] || params["password"]
    end

    def authenticate!
      account = account_repo.by_email(params["email"])

      if account && BCrypt::Password.new(account.password_hash) == request.params["password"]
        return success!(account)
      end

      fail!("Could not log in")
    end
  end
end

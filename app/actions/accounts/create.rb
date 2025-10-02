require "bcrypt"

module AdhDiary
  module Actions
    module Accounts
      class Create < AdhDiary::Action
        include Deps[account_repo: "repos.account_repo"]

        contract do
          params do
            required(:account).hash do
              required(:email).filled(:string)
              required(:name).filled(:string)
              required(:password).filled(:string)
              required(:password_confirmation).filled(:string)
            end
          end

          rule("account.password_confirmation", "account.password") do
            if value != values["account.password"]
              key.failure("must match password")
            end
          end
        end

        def handle(request, response)
          # raise "boom"
          # halt 422, {errors: request.params.errors}.to_json unless request.params.valid?
          # halt 422, { errors: "Password must match the confirmation" }.to_json unless request.params[:password] == request.params[:password_confirmation]
          # halt 422, { errors: "This email is already taken" }.to_json if accounts_repo.email_taken?(request.params[:email])

          if request.params.valid?
            password_salt = BCrypt::Engine.generate_salt
            password_hash = BCrypt::Engine.hash_secret(request.params[:account][:password], password_salt)
            account_repo.create(
              name: request.params[:account][:name],
              email: request.params[:account][:email],
              password_hash: password_hash,
              password_salt: password_salt
            )

            response.flash[:notice] = "Account created"
            response.redirect_to routes.path(:root)
          else
            response.flash.now[:alert] = "Could not create account"
            errors = request.params.errors[:account].to_h

            # unless existing_entries.zero?
            #   errors[:date] = [] unless errors.key?(:date)
            #   errors[:date] << "already exists"
            # end
            response.render(
              view,
              values: request.params[:account],
              errors:
            )
            # Implicitly re-renders the "new" view
          end
        end
      end
    end
  end
end

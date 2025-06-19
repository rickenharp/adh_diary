require "bcrypt"

module AdhDiary
  module Actions
    module Users
      class Create < AdhDiary::Action
        include Deps[users_repo: "repos.user_repo"]

        contract do
          params do
            required(:user).hash do
              required(:email).filled(:string)
              required(:name).filled(:string)
              required(:password).filled(:string)
              required(:password_confirmation).filled(:string)
            end
          end

          rule("user.password_confirmation", "user.password") do
            if value != values["user.password"]
              key.failure("must match password")
            end
          end
        end

        def handle(request, response)
          # raise "boom"
          # halt 422, {errors: request.params.errors}.to_json unless request.params.valid?
          # halt 422, { errors: "Password must match the confirmation" }.to_json unless request.params[:password] == request.params[:password_confirmation]
          # halt 422, { errors: "This email is already taken" }.to_json if users_repo.email_taken?(request.params[:email])

          if request.params.valid?
            password_salt = BCrypt::Engine.generate_salt
            password_hash = BCrypt::Engine.hash_secret(request.params[:user][:password], password_salt)
            users_repo.create(
              name: request.params[:user][:name],
              email: request.params[:user][:email],
              password_hash: password_hash,
              password_salt: password_salt
            )

            response.flash[:notice] = "User created"
            response.redirect_to routes.path(:root)
          else
            response.flash.now[:alert] = "Could not create user"
            errors = request.params.errors[:user].to_h

            # unless existing_entries.zero?
            #   errors[:date] = [] unless errors.key?(:date)
            #   errors[:date] << "already exists"
            # end
            response.render(
              view,
              values: request.params[:user],
              errors:
            )
            # Implicitly re-renders the "new" view
          end
        end
      end
    end
  end
end

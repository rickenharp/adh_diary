module AdhDiary
  module Actions
    module Sessions
      class Create < AdhDiary::Action
        include Deps[
          user_repo: "repos.user_repo",
          view: "views.login.new"
                ]

        params do
          required(:email).filled(:string)
          required(:password).filled(:string)
        end

        def handle(request, response)
          # halt 422, {errors: request.params.errors}.to_json unless request.params.valid?

          if request.params.valid?
            user = request.env["warden"].authenticate!
          end

          # if request.params.valid?
          #   user = user_repo.by_email(request.params[:email])
          # end

          if user
            response.flash[:notice] = "Login successful"
            request.session[:user_id] = user.id
            response.redirect "/"
          else
            response.flash.now[:alert] = "Email or password is invalid"
            errors = request.params.errors.to_h

            response.render(
              view,
              values: request.params,
              errors:
            )
            # Implicitly re-renders the "new" view
          end
        end
      end
    end
  end
end

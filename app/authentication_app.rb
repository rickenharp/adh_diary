require "roda"
require "rodauth"
require "rodauth/hanami"

module AdhDiary
  class AuthenticationApp < Roda
    Hanami.app.start :mail
    # Make the Roda app available as a middleware
    plugin :middleware

    plugin :rodauth do
      enable(
        :change_login,
        :change_password,
        :change_password_notify,
        :create_account,
        :login,
        :logout,
        :remember,
        :reset_password,
        :verify_account,
        :verify_login_change
      )

      enable :hanami
      hanami_view_class -> { AdhDiary::View }

      # Email configuration
      email_from "mail@rickenharp.cloud"
      email_subject_prefix "[AdhDiary] "

      # Use our own database connection, and simplify database operation: keep the password hash
      # column directly in the accounts table, and skip using database-level functions.
      db AdhDiary::App["db.gateway"].connection
      account_password_hash_column :password_hash
      use_database_authentication_functions? false

      # Don't require new passwords to be entered twice
      require_password_confirmation? false

      # Allow the password to be provided before verifying the account
      verify_account_set_password? false

      login_return_to_requested_location? true
      logout_redirect "/"
      already_logged_in { redirect "/" }

      login_route "sign-in"
      logout_route "sign-out"
      create_account_route "sign-up"
      verify_account_resend_route "resend-verify-account"
      change_login_route "account/change-email"
      change_password_route "account/change-password"
      verify_login_change_route "verify-email-change"
      reset_password_request_route "forgot-password"
      reset_password_route "reset-password"

      flash_error_key :alert

      login_page_title "Log in"
      login_form_footer_links_heading '<h2 class="subtitle">Other Options</h2>'
      login_label "Email"

      before_create_account do
        throw_error_status(422, "name", "must be present") if param("name").empty?
        account[:name] = param("name")
      end

      # after_create_account do
      #   db[:users].insert(
      #     account_id: account[:id],
      #     name: param("name"),
      #     email: param("login")
      #   )
      # end

      after_login do
        remember_login
      end

      account_password_hash_column :password_hash
      use_database_authentication_functions? false
    end

    route do |r|
      # Put the Rodauth instance in the Rack env, so we
      # can access it from Hanami
      env["rodauth"] = rodauth

      # Enable the Rodauth routes
      r.rodauth
    end
  end
end

# auto_register: false

module AdhDiary
  module Views
    class Context < Hanami::View::Context
      include Deps["repos.account_repo"]

      def signed_in?
        rodauth.logged_in?
      end

      def current_account
        return @current_account if instance_variable_defined?(:@current_account)

        # Load the account before attempting to get its ID
        @current_account = if rodauth.logged_in?
          rodauth.account_from_session

          account_repo.by_id(rodauth.account_id) if rodauth.account_id
        end
      end

      def rodauth
        request.env["rodauth"]
      end
    end
  end
end

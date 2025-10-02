# frozen_string_literal: true

module AdhDiary
  module Withings
    class GetToken
      include Dry::Monads[:result]

      def call(account:)
        if (access_token = account.access_token_for("withings"))
          Success(access_token)
        else
          Failure(:no_token)
        end
      end
    end
  end
end

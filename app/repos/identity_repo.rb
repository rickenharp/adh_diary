# frozen_string_literal: true

module AdhDiary
  module Repos
    class IdentityRepo < AdhDiary::DB::Repo
      include Deps["repos.account_repo"]

      commands :upsert, :create

      def new_from_omniauth(auth)
        account = account_repo.get(account.id)
        new_identity = identities.changeset(:create, provider: auth[:provider], uid: auth[:uid]).associate(account)
        new_identity.commit
      end

      def count(provider: nil)
        if provider.nil?
          identities.count
        else
          identities.where(provider: provider).count
        end
      end

      def by_id(id)
        identities.by_pk(id).one!
      end

      # def update_token(token)
      #   identities.where(account_id: account.id, provider: "withings").changeset(:update, access_token: token.token, refresh_token: token.refresh_token, expires_at: token.expires_at).commit
      # end
    end
  end
end

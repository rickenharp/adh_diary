# frozen_string_literal: true

module AdhDiary
  module Repos
    class IdentityRepo < AdhDiary::DB::Repo
      include Deps["repos.user_repo"]

      commands :upsert, :create

      def new_from_omniauth(auth)
        user = user_repo.get(user.id)
        new_identity = identities.changeset(:create, provider: auth[:provider], uid: auth[:uid]).associate(user)
        new_identity.commit
      end

      def count(provider: nil)
        if provider.nil?
          identities.count
        else
          identities.where(provider: provider).count
        end
      end
    end
  end
end

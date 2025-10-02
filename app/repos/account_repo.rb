# frozen_string_literal: true

module AdhDiary
  module Repos
    class AccountRepo < AdhDiary::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def query(conditions)
        accounts.where(conditions)
      end

      def email_taken?(email)
        accounts.exist?(email: email)
      end

      def by_id(id)
        accounts.by_pk(id).combine(:identities).one!
      end

      def by_email(email)
        accounts.where(email:).one
      end

      def update_locale(lang)
        accounts.where(id: account.id).changeset(:update, locale: lang.to_s).commit
      end

      # def update_withings_token(token)
      #   accounts.where(id: account.id).changeset(:update, withings_token: token).commit
      # end
    end
  end
end

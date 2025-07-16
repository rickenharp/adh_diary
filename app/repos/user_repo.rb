# frozen_string_literal: true

module AdhDiary
  module Repos
    class UserRepo < AdhDiary::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def query(conditions)
        users.where(conditions)
      end

      def email_taken?(email)
        users.exist?(email: email)
      end

      def by_id(id)
        users.by_pk(id).combine(:identities).one!
      end

      def by_email(email)
        users.where(email:).one
      end

      def update_locale(lang)
        users.where(id: user.id).changeset(:update, locale: lang.to_s).commit
      end

      # def update_withings_token(token)
      #   users.where(id: user.id).changeset(:update, withings_token: token).commit
      # end
    end
  end
end

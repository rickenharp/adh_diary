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
        users.by_pk(id).one!
      end

      def by_email(email)
        users.where(email:).one
      end
    end
  end
end

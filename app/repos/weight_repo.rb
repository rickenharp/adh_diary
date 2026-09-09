# frozen_string_literal: true

module AdhDiary
  module Repos
    class WeightRepo < AdhDiary::DB::Repo
      include Deps["current_account"]

      commands update: :by_pk, delete: :by_pk

      def all(order: :asc)
        weights.order { (order == :asc) ? date.asc : date.desc }.to_a
      end

      def get(date: Date.today, account_id: current_account.id)
        weights.by_pk(account_id, date).one!
      end

      def create(attributes)
        weights.changeset(:create, attributes).commit
      end
    end
  end
end

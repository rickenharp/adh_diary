# frozen_string_literal: true

module AdhDiary
  module Repos
    class EntryRepo < AdhDiary::DB::Repo
      def all(order: :asc)
        entries.order { (order == :asc) ? date.asc : date.desc }.to_a
      end

      def get(id)
        entries.by_pk(id).one!
      end

      def on(date)
        entries.where(Sequel.lit("date(date) = ?", date.to_date.to_s))
      end

      def create(attributes)
        entries.changeset(:create, attributes).commit
      end
    end
  end
end

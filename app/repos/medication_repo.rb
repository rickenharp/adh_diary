# frozen_string_literal: true

module AdhDiary
  module Repos
    class MedicationRepo < AdhDiary::DB::Repo
      commands update: :by_pk, delete: :by_pk

      def all(order: :asc)
        medications.order { (order == :asc) ? name.asc : name.desc }.to_a
      end

      def get(id)
        medications.by_pk(id).one!
      end

      def create(attributes)
        medications.changeset(:create, attributes).commit
      end
    end
  end
end

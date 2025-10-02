# frozen_string_literal: true

module AdhDiary
  module Repos
    class MedicationScheduleRepo < AdhDiary::DB::Repo
      def all(order: :asc)
        medication_schedules.where(account_id: account.id).combine(:medications).to_a
      end

      def get(id)
        medication_schedules.where(account_id: account.id).combine(:medications).by_pk(id).one!
      end

      def create(attributes)
        medication_schedules.changeset(:create, attributes.merge(account_id: account.id)).commit
      end

      def update(id, attributes)
        medication_schedules.where(account_id: account.id).by_pk(id).changeset(:update, attributes).commit
      end

      def delete(id)
        medication_schedules.where(account_id: account.id).by_pk(id).changeset(:delete).commit
      end
    end
  end
end

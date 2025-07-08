# frozen_string_literal: true

module AdhDiary
  module Repos
    class MedicationScheduleRepo < AdhDiary::DB::Repo
      commands update: :by_pk, delete: :by_pk

      def all(order: :asc)
        medication_schedules.combine(:medications).to_a
      end

      def get(id)
        medication_schedules.combine(:medications).by_pk(id).one!
      end

      def create(attributes)
        medication_schedules.changeset(:create, attributes).commit
      end
    end
  end
end

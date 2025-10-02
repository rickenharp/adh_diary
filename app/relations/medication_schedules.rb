# frozen_string_literal: true

module AdhDiary
  module Relations
    class MedicationSchedules < AdhDiary::DB::Relation
      schema :medication_schedules, infer: true do
        associations do
          belongs_to :medication
          belongs_to :account
          has_many :entries
        end
      end
    end
  end
end

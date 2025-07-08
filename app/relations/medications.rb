# frozen_string_literal: true

module AdhDiary
  module Relations
    class Medications < AdhDiary::DB::Relation
      schema :medications, infer: true do
        associations do
          has_many :entries
          has_many :medication_schedules
        end
      end
    end
  end
end

# frozen_string_literal: true

module AdhDiary
  module Relations
    class Entries < AdhDiary::DB::Relation
      use :pagination
      per_page 10
      schema :entries, infer: true do
        associations do
          belongs_to :account
          belongs_to :medication_schedule
          has_one :medication, through: :medication_schedules
        end
      end
    end
  end
end

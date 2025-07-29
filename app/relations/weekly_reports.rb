# frozen_string_literal: true

module AdhDiary
  module Relations
    class WeeklyReports < AdhDiary::DB::Relation
      schema :weekly_reports, infer: true do
        associations do
          belongs_to :user
        end
      end
    end
  end
end

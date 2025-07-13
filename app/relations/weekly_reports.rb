# frozen_string_literal: true

module AdhDiary
  module Relations
    class WeeklyReports < AdhDiary::DB::Relation
      MyDate = ROM::SQL::Types.define(Date) do
        input { |date| date.to_d }
        output { |db_string| Date.parse(db_string) }
      end
      schema :weekly_reports, infer: true do
        attribute :from, MyDate
        attribute :to, MyDate
        associations do
          belongs_to :user
        end
      end
    end
  end
end

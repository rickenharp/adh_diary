# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module WeeklyReports
      class Show < AdhDiary::View
        include Deps["repos.report_repo"]

        expose :report, as: Parts::WeeklyReport do |week:|
          report_repo.get_week(week)
        end

        def calculate_week(week, distance)
          other_date = Date.strptime(week, "%Y-W%W") + distance
          other_date.strftime("%Y-W%W")
        end

        expose :previous_week do |week:|
          previous_week = calculate_week(week, -7)
          OpenStruct.new(
            exist?: report_repo.for_week(previous_week).count > 0,
            week: previous_week
          )
        end

        expose :next_week do |week:|
          next_week = calculate_week(week, 7)
          OpenStruct.new(
            exist?: report_repo.for_week(next_week).count > 0,
            week: next_week
          )
        end
      end
    end
  end
end

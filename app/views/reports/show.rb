# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module Reports
      class Show < AdhDiary::View
        include Deps["repos.weekly_report_repo"]

        expose :entry do |week:|
          weekly_report_repo.get(week)
        end

        def entry_count_for_week(week, distance)
          count = weekly_report_repo.for_week(week).count
          if count.zero?
            nil
          else
            other_date.strftime("%Y-W%W")
          end
        end

        def calculate_week(week, distance)
          other_date = Date.strptime(week, "%Y-W%W") + distance
          other_date.strftime("%Y-W%W")
        end

        expose :previous_week do |week:|
          previous_week = calculate_week(week, -7)
          OpenStruct.new(
            count: weekly_report_repo.for_week(previous_week).count,
            week: previous_week
          )
        end

        expose :next_week do |week:|
          next_week = calculate_week(week, 7)
          OpenStruct.new(
            count: weekly_report_repo.for_week(next_week).count,
            week: next_week
          )
        end
      end
    end
  end
end

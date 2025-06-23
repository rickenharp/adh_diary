# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module Reports
      class Show < AdhDiary::View
        include Deps["repos.entry_repo"]

        expose :entry do |week:|
          entry_repo.for_week(week)
        end

        def entry_count_for_week(week, distance)
          count = entry_repo.entries_for_week(week)
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
            count: entry_repo.entries_for_week(previous_week),
            week: previous_week
          )
        end

        expose :next_week do |week:|
          next_week = calculate_week(week, 7)
          OpenStruct.new(
            count: entry_repo.entries_for_week(next_week),
            week: next_week
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

require "ostruct"

module AdhDiary
  module Views
    module MonthlyReports
      class Show < AdhDiary::View
        include Deps["repos.report_repo"]

        expose :report, as: Parts::Report do |month:|
          report_repo.get_month(month)
        end

        expose :previous_month do |month:|
          previous_month = Date.strptime(month, "%Y-%m").prev_month.strftime("%Y-%m")
          OpenStruct.new(
            exist?: report_repo.for_month(previous_month).count > 0,
            month: previous_month
          )
        end

        expose :next_month do |month:|
          next_month = Date.strptime(month, "%Y-%m").next_month.strftime("%Y-%m")
          OpenStruct.new(
            exist?: report_repo.for_month(next_month).count > 0,
            month: next_month
          )
        end
      end
    end
  end
end

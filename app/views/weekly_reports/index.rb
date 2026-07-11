# frozen_string_literal: true

module AdhDiary
  module Views
    module WeeklyReports
      class Index < AdhDiary::View
        include Deps["repos.report_repo"]

        expose :weeks do
          report_repo.weekly
        end
      end
    end
  end
end

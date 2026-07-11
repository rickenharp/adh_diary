# frozen_string_literal: true

module AdhDiary
  module Views
    module MonthlyReports
      class Index < AdhDiary::View
        include Deps["repos.report_repo"]

        expose :months do
          report_repo.monthly
        end
      end
    end
  end
end

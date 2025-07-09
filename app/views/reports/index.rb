# frozen_string_literal: true

module AdhDiary
  module Views
    module Reports
      class Index < AdhDiary::View
        include Deps["repos.weekly_report_repo"]

        expose :weeks do
          weekly_report_repo.weeks
        end
      end
    end
  end
end

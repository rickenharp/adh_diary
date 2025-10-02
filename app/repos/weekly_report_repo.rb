# frozen_string_literal: true

module AdhDiary
  module Repos
    class WeeklyReportRepo < AdhDiary::DB::Repo
      def all
        weekly_reports.where(account_id: account.id).to_a
      end

      def weeks
        weekly_reports.select(:week).where(account_id: account.id).to_a
      end

      def for_week(week)
        weekly_reports.where(account_id: account.id, week: week).combine(:account)
      end

      def get(week)
        for_week(week).one!
      end
    end
  end
end

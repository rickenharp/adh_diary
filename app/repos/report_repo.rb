# frozen_string_literal: true

module AdhDiary
  module Repos
    class ReportRepo < AdhDiary::DB::Repo[:entries]
      include Deps["current_account", "relations.accounts", "relations.medications"]

      # def data_for_bpm_diagram(date_format:, range:)
      #   entries.select {
      #     [
      #       date,
      #       integer.cast(array.split_part(blood_pressure, "/", 1)).as(:sys),
      #       integer.cast(array.split_part(blood_pressure, "/", 2)).as(:dia),
      #       weight
      #     ]
      #   }.where { string.to_char(date, date_format) =~ range }
      #     .order(:date)
      # end

      def report(type, date_format)
        meds = medications[:name]
        account_name = accounts[:name]
        entries.select {
          [
            account_name,
            function(:to_char, date, date_format).as(type),
            function(:array_agg, date).order(date).sql_subscript(1).as(:from),
            function(:array_agg, date).order(date.desc).sql_subscript(1).as(:to),
            integer.cast(integer.round(float.avg(attention), 0)).as(:attention),
            integer.cast(integer.round(float.avg(organisation), 0)).as(:organisation),
            integer.cast(integer.round(float.avg(mood_swings), 0)).as(:mood_swings),
            integer.cast(integer.round(float.avg(stress_sensitivity), 0)).as(:stress_sensitivity),
            integer.cast(integer.round(float.avg(irritability), 0)).as(:irritability),
            integer.cast(integer.round(float.avg(restlessness), 0)).as(:restlessness),
            integer.cast(integer.round(float.avg(impulsivity), 0)).as(:impulsivity),
            string.string_agg(string.nullif(side_effects, ""), ",").as(:side_effects),
            array.array_agg(blood_pressure).order(:date).as(:blood_pressure),
            array.array_agg(date).order(date).as(:dates),
            array.array_agg(weight).order(date).as(:weights),
            array.array_remove(array.array_agg(weight).order(date.desc), nil).sql_subscript(1).as(:weight),
            array.array_agg(string.concat(meds, " ", :morning, " mg")).distinct.as(:medication)

          ]
        }.left_join(:medications).left_join(:accounts)
          .group { [type, entries[:account_id], accounts[:name]] }
          .order(type)
          .where(entries[:account_id].is(current_account.id))
      end

      def weekly
        report(:week, 'IYYY-"W"IW')
      end

      def weeks
        weekly.pluck(:week).to_a
      end

      def for_week(week)
        weekly.where { string.to_char(date, 'IYYY-"W"IW') =~ week }
      end

      def get_week(week)
        for_week(week).one
      end

      def monthly
        report(:month, "YYYY-MM")
      end

      def months
        monthly.pluck(:month).to_a
      end

      def for_month(month)
        monthly.where { string.to_char(date, "YYYY-MM") =~ month }
      end

      def get_month(month)
        for_month(month).one
      end
    end
  end
end

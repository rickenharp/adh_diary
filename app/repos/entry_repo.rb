# frozen_string_literal: true

module AdhDiary
  module Repos
    class EntryRepo < AdhDiary::DB::Repo
      def all(order: :asc, page: 1)
        entries.combine(medication_schedules: :medications).where(account_id: account.id).order { (order == :asc) ? date.asc : date.desc }.page(page)
      end

      def last_entry
        entries.where(account_id: account.id).order { date.desc }.limit(1).one
      end

      def get(id)
        entries.where(account_id: account.id).combine(medication_schedules: :medications).by_pk(id).one!
      end

      def on(date)
        entries.where(account_id: account.id).combine(medication_schedules: :medications).where(Sequel.lit("date(date) = ?", date.to_date.to_s))
      end

      def weeks_base
        entries.where(account_id: account.id).select { [function(:strftime, "%Y-W%W", date).as(:week)] }.group { week }.order(:date)
      end

      def weeks
        weeks_base.to_a
      end

      def entries_for_week(the_week)
        weeks_base.having(week: the_week).count
      end

      def for_week(the_week)
        entries.left_join(:medications).where(Sequel[:entries][:account_id] => account.id).select {
          [
            function(:strftime, "%Y-W%W", date).as(:week),
            integer.min(date).as(:from),
            integer.max(date).as(:to),
            integer.cast(function(:round, function(:avg, attention))).as(:attention),
            integer.cast(function(:round, function(:avg, organisation))).as(:organisation),
            integer.cast(function(:round, function(:avg, mood_swings))).as(:mood_swings),
            integer.cast(function(:round, function(:avg, stress_sensitivity))).as(:stress_sensitivity),
            integer.cast(function(:round, function(:avg, irritability))).as(:irritability),
            integer.cast(function(:round, function(:avg, restlessness))).as(:restlessness),
            integer.cast(function(:round, function(:avg, impulsivity))).as(:impulsivity),

            string.group_concat(string.nullif(side_effects, "")).as(:side_effects),
            string.group_concat(blood_pressure).order(:date).as(:blood_pressure),
            function(:json_extract, function(:json_group_array, weight), "$[#-1]").as(:weight),
            function(
              :replace,
              string.group_concat(
                string.concat(
                  Sequel[:medications][:name], " ",
                  integer.cast(Sequel[:medication_schedules][:morning]), "-",
                  integer.cast(Sequel[:medication_schedules][:noon]), "-",
                  integer.cast(Sequel[:medication_schedules][:evening]), "-",
                  integer.cast(Sequel[:medication_schedules][:before_bed])
                )
              ).order(:date).distinct,
              ",",
              ", "
            ).as(:medication)
          ]
        }.group { week }.having(week: the_week).one
      end

      def create(attributes)
        entries.changeset(:create, attributes.merge(account_id: account.id)).commit
      end

      def update(id, attributes)
        entries.where(account_id: account.id).by_pk(id).changeset(:update, attributes).commit
      end

      def delete(id)
        entries.where(account_id: account.id).by_pk(id).changeset(:delete).commit
      end
    end
  end
end

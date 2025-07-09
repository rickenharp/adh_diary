# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    alter_table(:entries) do
      add_foreign_key :medication_schedule_id, :medication_schedules
    end

    execute <<~SQL
      UPDATE
        entries
      SET
        medication_schedule_id = (
          SELECT
            medication_schedules.id
          FROM
            medication_schedules
          WHERE
            medication_schedules.user_id = entries.user_id
            AND entries.medication_id = medication_schedules.medication_id
            AND medication_schedules.morning = entries.dose
        )
        WHERE medication_schedule_id IS NULL
    SQL

    alter_table(:entries) do
      set_column_not_null :medication_schedule_id
      drop_foreign_key :medication_id
      drop_column :dose
    end

    create_or_replace_view(
      :weekly_reports,
      Hanami.app["relations.entries"].left_join(:medications).select {
        [
          user_id,
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
      }.group { week }.dataset
    )
  end

  down do
    drop_view(:weekly_reports)
    alter_table(:entries) do
      add_foreign_key :medication_id, :medications
      add_column :dose, Float
    end

    execute <<~SQL
      UPDATE
        entries
      SET
        dose = (
          SELECT
            medication_schedules.morning
          FROM
            medication_schedules
          WHERE
            medication_schedules.id = entries.medication_schedule_id
        ),
        medication_id = (
          SELECT
            medication_schedules.medication_id
          FROM
            medication_schedules
          WHERE
            medication_schedules.id = entries.medication_schedule_id
        )
      WHERE
        medication_schedule_id IS NOT NULL
    SQL

    alter_table(:entries) do
      set_column_not_null :medication_id
      drop_foreign_key :medication_schedule_id
    end
  end
end

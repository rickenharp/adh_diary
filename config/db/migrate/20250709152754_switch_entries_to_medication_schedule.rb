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
      ROM::SQL.current_gateway[:entries].left_join(:medications).select {
        [
          user_id,
          function(:strftime, "%Y-W%W", date).as(:week),
          min(date).as(:from),
          max(date).as(:to),
          function(:round, function(:avg, attention)).as(:attention),
          function(:round, function(:avg, organisation)).as(:organisation),
          function(:round, function(:avg, mood_swings)).as(:mood_swings),
          function(:round, function(:avg, stress_sensitivity)).as(:stress_sensitivity),
          function(:round, function(:avg, irritability)).as(:irritability),
          function(:round, function(:avg, restlessness)).as(:restlessness),
          function(:round, function(:avg, impulsivity)).as(:impulsivity),

          group_concat(nullif(side_effects, "")).as(:side_effects),
          group_concat(blood_pressure).order(:date).as(:blood_pressure),
          function(:json_extract, function(:json_group_array, weight), "$[#-1]").as(:weight),
          function(
            :replace,
            group_concat(
              concat(
                Sequel[:medications][:name], " ",
                Sequel[:medication_schedules][:morning], "-",
                Sequel[:medication_schedules][:noon], "-",
                Sequel[:medication_schedules][:evening], "-",
                Sequel[:medication_schedules][:before_bed]
              )
            ).order(:date).distinct,
            ",",
            ", "
          ).as(:medication)
        ]
      }.group { week }
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

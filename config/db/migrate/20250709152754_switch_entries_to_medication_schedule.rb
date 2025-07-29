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
      ROM::SQL.current_gateway[:entries].select {
        [
          entries[:user_id].as(:user_id),
          to_char(:date, 'IYYY-"W"IW').as(:week),
          min(date).as(:from),
          max(date).as(:to),
          round(avg(attention)).cast(:integer).as(:attention),
          round(avg(organisation)).cast(:integer).as(:organisation),
          round(avg(mood_swings)).cast(:integer).as(:mood_swings),
          round(avg(stress_sensitivity)).cast(:integer).as(:stress_sensitivity),
          round(avg(irritability)).cast(:integer).as(:irritability),
          round(avg(restlessness)).cast(:integer).as(:restlessness),
          round(avg(impulsivity)).cast(:integer).as(:impulsivity),

          string_agg(nullif(:side_effects, ""), ",").as(:side_effects),
          array_agg(:blood_pressure).order(:date).as(:blood_pressure),
          array_agg(:weight).order(:date).sql_subscript(1).as("weight"),

          array_agg(
            concat(
              medications[:name], " ",
              medication_schedules[:morning], "-",
              medication_schedules[:noon], "-",
              medication_schedules[:evening], "-",
              medication_schedules[:before_bed]
            )
          ).order(:date).as(:medication)

        ]
      }
              .left_join(:medication_schedules, id: :medication_schedule_id).left_join(:medications, id: :medication_id)
              .group { [to_char(:date, 'IYYY-"W"IW'), entries[:user_id], :date] }
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

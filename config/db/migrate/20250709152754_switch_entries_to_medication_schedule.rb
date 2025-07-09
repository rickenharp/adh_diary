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
  end

  down do
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

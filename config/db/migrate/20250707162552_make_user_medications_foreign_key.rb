# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    alter_table(:entries) do
      add_foreign_key :medication_id, :medications
    end

    execute <<~SQL
      UPDATE entries
      SET medication_id = medications.id
      from medications
      where entries.medication = medications.name
    SQL

    alter_table(:entries) do
      set_column_not_null :medication_id
      drop_column :medication
    end
  end

  down do
    alter_table(:entries) do
      add_column :medication, String
    end

    execute <<~SQL
      UPDATE entries
      SET medication = medications.name
      from medications
      where entries.medication_id = medications.id
    SQL

    alter_table(:entries) do
      set_column_not_null :medication
      drop_foreign_key :medication_id
    end
  end
end

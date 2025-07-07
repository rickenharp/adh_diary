# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    transaction do
      create_table :medications do
        column :id, Integer, primary_key: true
        column :name, String, null: false, unique: true
      end
      execute <<~SQL
        INSERT INTO medications (name)
        SELECT DISTINCT medication
        FROM entries WHERE true
        ON CONFLICT(name) DO NOTHING
      SQL
    end
  end

  down do
    drop_table :medications
  end
end

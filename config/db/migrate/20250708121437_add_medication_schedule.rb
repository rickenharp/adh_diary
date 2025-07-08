# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    create_table :medication_schedules do
      primary_key :id
      foreign_key :medication_id, :medications
      foreign_key :user_id, :users
      column :morning, Float, default: 0
      column :noon, Float, default: 0
      column :evening, Float, default: 0
      column :before_bed, Float, default: 0
      column :notes, String
    end

    execute <<~SQL
      INSERT INTO medication_schedules (user_id, medication_id, morning)
      SELECT DISTINCT user_id, medication_id, dose
      FROM entries
      LEFT JOIN medications ON entries.medication_id = medications.id
    SQL
  end

  down do
    drop_table :medication_schedules
  end
end

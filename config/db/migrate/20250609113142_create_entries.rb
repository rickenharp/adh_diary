# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.

  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  change do
    create_table :entries do
      primary_key :id

      column :date, Date, null: false, unique: true, index: true
      column :attention, Integer, null: false
      column :organisation, Integer, null: false
      column :mood_swings, Integer, null: false
      column :stress_sensitivity, Integer, null: false
      column :irritability, Integer, null: false
      column :restlessness, Integer, null: false
      column :impulsivity, Integer, null: false
      column :side_effects, String
      column :blood_pressure, String
      column :weight, Float, null: false
    end
  end
end

# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://hanakai.org/learn/hanami/database/migrations/ for details.
  up do
    create_table :weights do
      foreign_key :account_id, :accounts
      column :weight, Float
      column :date, Date
      primary_key [:date, :account_id]
    end

    execute <<~SQL
      INSERT INTO weights (date, weight, account_id)
      SELECT date,weight, account_id
      FROM entries WHERE true
    SQL

    alter_table(:entries) do
      rename_column :weight, :weight_old
    end
  end

  down do
    alter_table(:entries) do
      rename_column :weight_old, :weight
    end
    drop_table :weights
  end
end

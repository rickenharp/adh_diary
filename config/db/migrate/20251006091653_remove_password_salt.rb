# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    run "CREATE EXTENSION IF NOT EXISTS pgcrypto"

    alter_table :accounts do
      drop_column :password_salt
    end
  end

  down do
    alter_table :accounts do
      add_column :password_salt, String, null: true
    end

    execute <<~SQL
      UPDATE accounts SET password_salt=LEFT(password_hash, 29)
    SQL

    alter_table :accounts do
      set_column_not_null :password_salt
    end

    run "DROP EXTENSION IF EXISTS pgcrypto"
  end
end

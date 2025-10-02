# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    rename_table(:users, :accounts)

    execute <<~SQL
      ALTER SEQUENCE public.users_id_seq RENAME TO accounts_id_seq;
    SQL

    alter_table(:accounts) do
      drop_index :email, name: "users_email_index"
      add_index :email, unique: true
      rename_constraint("users_pkey", "accounts_pkey")
    end

    alter_table(:entries) do
      rename_column :user_id, :account_id
      rename_constraint("entries_user_id_fkey", "entries_account_id_fkey")
    end

    alter_table(:identities) do
      rename_column :user_id, :account_id
      drop_index "user_id_provider"
      add_index [:account_id, :provider], unique: true
      rename_constraint("identities_user_id_fkey", "identities_account_id_fkey")
    end

    alter_table(:medication_schedules) do
      rename_column :user_id, :account_id
      rename_constraint("medication_schedules_user_id_fkey", "medication_schedules_account_id_fkey")
    end

    drop_view :weekly_reports
    create_or_replace_view(
      :weekly_reports,
      ROM::SQL.current_gateway[:entries].select {
        [
          entries[:account_id].as(:account_id),
          to_char(:date, 'IYYY-"W"IW').as(:week),
          array_agg(:date).order(:date).sql_subscript(1).as("from"),
          array_agg(:date).order(Sequel.desc(:date)).sql_subscript(1).as("to"),
          round(avg(:attention)).cast(:integer).as(:attention),
          round(avg(:organisation)).cast(:integer).as(:organisation),
          round(avg(:mood_swings)).cast(:integer).as(:mood_swings),
          round(avg(:stress_sensitivity)).cast(:integer).as(:stress_sensitivity),
          round(avg(:irritability)).cast(:integer).as(:irritability),
          round(avg(:restlessness)).cast(:integer).as(:restlessness),
          round(avg(:impulsivity)).cast(:integer).as(:impulsivity),
          string_agg(nullif(:side_effects, ""), ",").as(:side_effects),
          array_agg(:blood_pressure).order(:date).as(:blood_pressure),
          array_agg(:weight).order(:date).sql_subscript(1).as("weight"),
          array_agg(concat(:name, " ", :morning, "mg")).distinct.as(:medication)
        ]
      }.group_by { [to_char(:date, 'IYYY-"W"IW'), entries[:account_id]] }
              .order(:week)
              .left_join(:medication_schedules, id: :medication_schedule_id)
              .left_join(:medications, id: :medication_id)
    )
  end

  down do
    rename_table(:accounts, :users)

    execute <<~SQL
      ALTER SEQUENCE public.accounts_id_seq RENAME TO users_id_seq;
    SQL

    alter_table(:users) do
      drop_index :email, name: "accounts_email_index"
      add_index :email, unique: true
      rename_constraint("accounts_pkey", "users_pkey")
    end

    alter_table(:entries) do
      rename_column :account_id, :user_id
      rename_constraint("entries_account_id_fkey", "entries_user_id_fkey")
    end

    alter_table(:identities) do
      rename_column :account_id, :user_id
      drop_index "account_id_provider"
      add_index [:user_id, :provider], unique: true
      rename_constraint("identities_account_id_fkey", "identities_user_id_fkey")
    end

    alter_table(:medication_schedules) do
      rename_column :account_id, :user_id
      rename_constraint("medication_schedules_account_id_fkey", "medication_schedules_user_id_fkey")
    end

    drop_view :weekly_reports
    create_or_replace_view(
      :weekly_reports,
      ROM::SQL.current_gateway[:entries].select {
        [
          entries[:user_id].as(:user_id),
          to_char(:date, 'IYYY-"W"IW').as(:week),
          array_agg(:date).order(:date).sql_subscript(1).as("from"),
          array_agg(:date).order(Sequel.desc(:date)).sql_subscript(1).as("to"),
          round(avg(:attention)).cast(:integer).as(:attention),
          round(avg(:organisation)).cast(:integer).as(:organisation),
          round(avg(:mood_swings)).cast(:integer).as(:mood_swings),
          round(avg(:stress_sensitivity)).cast(:integer).as(:stress_sensitivity),
          round(avg(:irritability)).cast(:integer).as(:irritability),
          round(avg(:restlessness)).cast(:integer).as(:restlessness),
          round(avg(:impulsivity)).cast(:integer).as(:impulsivity),
          string_agg(nullif(:side_effects, ""), ",").as(:side_effects),
          array_agg(:blood_pressure).order(:date).as(:blood_pressure),
          array_agg(:weight).order(:date).sql_subscript(1).as("weight"),
          array_agg(concat(:name, " ", :morning, "mg")).distinct.as(:medication)
        ]
      }.group_by { [to_char(:date, 'IYYY-"W"IW'), entries[:user_id]] }
              .order(:week)
              .left_join(:medication_schedules, id: :medication_schedule_id)
              .left_join(:medications, id: :medication_id)
    )
  end
end

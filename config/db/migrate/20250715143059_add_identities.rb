# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  change do
    create_table :identities do
      primary_key :id
      foreign_key :user_id, :users
      column :provider, String
      column :uid, String
      column :token, String
      column :refresh_token, String
      column :expires_at, Time
      index [:user_id, :provider], unique: true
    end
  end
end

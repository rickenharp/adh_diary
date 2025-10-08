# frozen_string_literal: true

require "database_cleaner/sequel"

# Clean the databases between tests tagged as `:db`

skip_cleaning_tables = %w[account_statuses]

RSpec.configure do |config|
  # Returns all the configured databases across the app and its slices.
  #
  # Used in the before/after hooks below to ensure each database is cleaned between examples.
  #
  # Modify this proc (or any code below) if you only need specific databases cleaned.
  all_databases = -> {
    slices = [Hanami.app] + Hanami.app.slices.with_nested

    slices.each_with_object([]) { |slice, dbs|
      next unless slice.key?("db.rom")

      dbs.concat slice["db.rom"].gateways.values.map(&:connection)
    }.uniq
  }

  config.before :suite do
    all_databases.call.each do |db|
      DatabaseCleaner[:sequel, db: db].clean_with :truncation, except: skip_cleaning_tables
    end
  end

  config.before :each, :db do |example|
    # strategy = example.metadata[:js] ? :deletion : :transaction
    all_databases.call.each do |db|
      DatabaseCleaner[:sequel, db: db].strategy = :truncation, {except: skip_cleaning_tables}
      DatabaseCleaner[:sequel, db: db].start
    end
  end

  config.after :each, :db do
    all_databases.call.each do |db|
      DatabaseCleaner[:sequel, db: db].clean
    end
  end
end

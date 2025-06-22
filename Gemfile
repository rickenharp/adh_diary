# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 2.2"
gem "hanami-assets", "~> 2.2"
gem "hanami-controller", "~> 2.2"
gem "hanami-db", "~> 2.2"
gem "hanami-router", "~> 2.2"
gem "hanami-validations", "~> 2.2"
gem "hanami-view", "~> 2.2"

gem "dry-types", "~> 1.7"
gem "dry-operation"
gem "puma"
gem "rackup"
gem "rake"
gem "sqlite3"

gem "warden"
gem "bcrypt"

group :development do
  gem "hanami-webconsole", "~> 2.2"
  gem "amazing_print"
end

group :development, :test do
  gem "dotenv"
  gem "standard"
  gem "irb"
  gem "launchy"
end

group :cli, :development do
  gem "hanami-reloader", "~> 2.2"
end

group :cli, :development, :test do
  gem "hanami-rspec", "~> 2.2"
end

group :test do
  # Database
  gem "database_cleaner-sequel"
  gem "rom-factory"

  # Web integration
  gem "capybara"
  gem "rack-test"
end

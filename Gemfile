# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 3.0"
gem "hanami-cli", "~> 3.0"
gem "hanami-assets", "~> 3.0"
gem "hanami-action", "~> 3.0"
gem "hanami-db", "~> 3.0"
gem "hanami-router", "~> 3.0"
gem "hanami-view", "~> 3.0"

gem "dry-types", "~> 1.7"
gem "dry-validation"
gem "dry-operation"
gem "puma"
gem "rake"
gem "pg"

gem "bcrypt"
gem "omniauth"
gem "omniauth-oauth2-generic"
gem "omniauth-oauth2"

gem "rodauth"
gem "mail"

gem "tilt", "~> 2.7"
gem "rubyzip", "~> 3.0"
gem "dry-effects", "~> 0.5.0"
gem "i18n", "~> 1.14"
gem "rack-unpoly", "~> 0.5.0"
gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.2.2"
gem "faraday", "~> 2.13"
gem "sentry-ruby", "~> 6.1"

gem "gruff"

group :development do
  gem "hanami-webconsole", "~> 3.0"
  gem "amazing_print"
  gem "yard"
  gem "maruku"
end

group :development, :test do
  gem "dotenv"
  gem "standard"
  gem "irb"
  gem "pry"
  gem "launchy"
  gem "rouge"
end

group :cli, :development do
  gem "hanami-reloader", "~> 3.0"
end

group :cli, :development, :test do
  gem "hanami-rspec", "~> 3.0"
end

group :test do
  # Database
  gem "database_cleaner-sequel"
  gem "rom-factory", git: "https://github.com/rickenharp/rom-factory", branch: "transient_attributes"

  # Web integration
  gem "capybara"
  gem "rack-test"
  gem "cuprite", "~> 0.17"

  gem "mimemagic", "~> 0.4.3"
  gem "webmock", "~> 3.26.1"
end

gem "openssl", "~> 4.0", ">= 3.3.1"
gem "uri", "~> 1.0", ">= 1.0.4"

# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 2.3"
gem "hanami-cli", "~> 2.3"
gem "hanami-assets", "~> 2.3"
gem "hanami-controller", "~> 2.3"
gem "hanami-db", "~> 2.3"
gem "hanami-router", "~> 2.3"
gem "hanami-validations", "~> 2.3"
gem "hanami-view", "~> 2.3"

gem "dry-types", "~> 1.7"
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

gem "tilt", git: "https://github.com/jeremyevans/tilt", branch: "master"
gem "rubyzip", "~> 3.0"
gem "dry-effects", "~> 0.5.0"
gem "i18n", "~> 1.14"
gem "rack-unpoly", "~> 0.5.0"
gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.2.2"
gem "faraday", "~> 2.13"
gem "sentry-ruby", "~> 6.1"

group :development do
  gem "hanami-webconsole", "~> 2.3"
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
  gem "i18n-missing_translations"
end

group :cli, :development do
  gem "hanami-reloader", "~> 2.3"
end

group :cli, :development, :test do
  gem "hanami-rspec", "~> 2.3"
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

gem "openssl", "~> 3.3", ">= 3.3.1"
gem "uri", "~> 1.0", ">= 1.0.4"

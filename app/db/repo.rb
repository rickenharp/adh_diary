# frozen_string_literal: true

require "hanami/db/repo"
require "dry-effects"

module AdhDiary
  module DB
    class Repo < Hanami::DB::Repo
      include Dry::Effects.Reader(:user)
    end
  end
end

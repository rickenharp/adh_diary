# frozen_string_literal: true

require "dry-effects"

module AdhDiary
  class CurrentAccount
    include Dry::Effects.Reader(:account)

    def id
      account&.id
    end

    def obj
      account
    end
  end
end

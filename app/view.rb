# auto_register: false
# frozen_string_literal: true

require "hanami/view"
require "dry-effects"

module AdhDiary
  class View < Hanami::View
    include Dry::Effects.Reader(:account)
  end
end

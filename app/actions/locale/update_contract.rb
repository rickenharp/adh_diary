# frozen_string_literal: true

module AdhDiary
  module Actions
    module Locale
      class UpdateContract < Dry::Validation::Contract
        include Deps["i18n"]

        params do
          required(:language).filled(:symbol)
        end

        rule(:language) do |context:|
          key.failure("is invalid") unless i18n.available_locales.include?(value)
        end
      end
    end
  end
end

# frozen_string_literal: true

module AdhDiary
  module Actions
    module Language
      class UpdateContract < Dry::Validation::Contract
        include Deps["i18n"]

        params do
          required(:lang).filled(:symbol)
        end

        rule(:lang) do |context:|
          # context[:available_locales] ||= i18n.available_locales
          key.failure("is invalid") unless i18n.available_locales.include?(value)
        end
      end
    end
  end
end

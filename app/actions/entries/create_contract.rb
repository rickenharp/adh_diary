# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class CreateContract < Dry::Validation::Contract
        include Deps["repos.entry_repo"]

        params(EntrySchema) do
        end

        rule("entry.date") do
          key.failure("already exists") if entry_repo.on(values["entry.date"]).count > 0
        end
      end
    end
  end
end

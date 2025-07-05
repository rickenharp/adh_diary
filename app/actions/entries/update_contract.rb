# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      class UpdateContract < Dry::Validation::Contract
        include Deps["repos.entry_repo"]

        params(EntrySchema) do
          required(:id).filled(:integer)
        end

        rule("entry.date", :id) do
          key.failure("already exists") if entry_repo.on(values["entry.date"]).where(Sequel.~(id: values[:id])).count > 0
        end
      end
    end
  end
end

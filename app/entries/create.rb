# frozen_string_literal: true

module AdhDiary
  module Entries
    class Create < AdhDiary::Operation
      include Deps["repos.entry_repo", "actions.entries.create_contract"]

      def call(params)
        attrs = step validate(params.to_h)
        step create(attrs[:entry])
      end

      def validate(params)
        create_contract.call(params).to_monad
      end

      def create(entry)
        Success(entry_repo.create(entry))
      end
    end
  end
end

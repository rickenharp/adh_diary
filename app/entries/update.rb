# frozen_string_literal: true

module AdhDiary
  module Entries
    class Update < AdhDiary::Operation
      include Deps["repos.entry_repo", "actions.entries.update_contract"]

      def call(params)
        attrs = step validate(params.to_h)
        step update(params[:id], attrs[:entry])
      end

      def validate(params)
        update_contract.call(params).to_monad
      end

      def update(id, attrs)
        Success(entry_repo.update(id, attrs))
      end
    end
  end
end

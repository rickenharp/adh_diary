# frozen_string_literal: true

module AdhDiary
  module Entries
    class Create < AdhDiary::Operation
      include Deps["repos.entry_repo", "actions.entries.create_contract"]

      def call(params, user_id)
        attrs = step validate(params.to_h)
        entry = step merge(attrs, user_id)
        step create(entry)
      end

      def validate(params)
        create_contract.call(params).to_monad
      end

      def merge(attrs, user_id)
        Success(attrs.to_h.fetch(:entry).merge(user_id: user_id))
      end

      def create(entry)
        Success(entry_repo.create(entry))
      end
    end
  end
end

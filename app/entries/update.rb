# frozen_string_literal: true

module AdhDiary
  module Entries
    class Update < AdhDiary::Operation
      include Deps["repos.entry_repo", "actions.entries.update_contract"]

      def call(params, user_id)
        attrs = step validate(params.to_h)
        entry = step merge(attrs, user_id)
        step update(params[:id], entry)
      end

      def validate(params)
        update_contract.call(params).to_monad
      end

      def merge(attrs, user_id)
        Success(attrs.to_h.fetch(:entry).merge(user_id: user_id))
      end

      def update(id, entry)
        Success(entry_repo.update(id, entry))
      end
    end
  end
end

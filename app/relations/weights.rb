# frozen_string_literal: true

module AdhDiary
  module Relations
    class Weights < AdhDiary::DB::Relation
      schema :weights, infer: true do
        associations do
          belongs_to :account
          has_one :entry, view: :for_weights, override: true, combine_keys: {date: :date, account_id: :account_id}
        end
      end

      def for_entries(assoc, entries)
        pairs = entries.map { |t| [t[:account_id], t[:date]] }.uniq
        where([:account_id, :date] => pairs)
      end
    end
  end
end

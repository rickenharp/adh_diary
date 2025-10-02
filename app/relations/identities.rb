# frozen_string_literal: true

module AdhDiary
  module Relations
    class Identities < AdhDiary::DB::Relation
      schema :identities, infer: true do
        associations do
          belongs_to :account
        end
      end
    end
  end
end

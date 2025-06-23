# frozen_string_literal: true

module AdhDiary
  module Relations
    class Entries < AdhDiary::DB::Relation
      use :pagination
      per_page 10
      schema :entries, infer: true do
        associations do
          belongs_to :user
        end
      end
    end
  end
end

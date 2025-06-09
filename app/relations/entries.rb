# frozen_string_literal: true

module AdhDiary
  module Relations
    class Entries < AdhDiary::DB::Relation
      schema :entries, infer: true
    end
  end
end

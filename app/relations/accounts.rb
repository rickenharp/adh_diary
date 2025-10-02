module AdhDiary
  module Relations
    class Accounts < ROM::Relation[:sql]
      schema(:accounts, infer: true) do
        associations do
          has_many :entries
          has_many :medication_schedules
          has_many :identities
        end
      end
    end
  end
end

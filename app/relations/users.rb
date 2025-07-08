module AdhDiary
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true) do
        associations do
          has_many :entries
          has_many :medication_schedules
        end
      end
    end
  end
end

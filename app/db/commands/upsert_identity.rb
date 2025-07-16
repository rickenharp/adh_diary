module AdhDiary
  module DB
    module Commands
      class UpsertIdentity < ROM::SQL::Commands::Create
        relation :identities
        register_as :upsert

        def execute(tuples)
          inserted_tuples = with_input_tuples(tuples) do |tuple|
            relation.dataset.returning.insert_conflict(target: [:user_id, :provider], update: {token: Sequel[:excluded][:token], uid: Sequel[:excluded][:uid]}).insert(tuples)
          end
          inserted_tuples.flatten(1)
        end

        def finalize(tuples, *)
          tuples.map { |t| relation.output_schema[t] }
        end
      end
    end
  end
end

module AdhDiary
  module DB
    module Commands
      class UpsertIdentity < ROM::SQL::Postgres::Commands::Upsert
        relation :identities
        register_as :upsert
        conflict_target [:user_id, :provider]
        update_statement token: Sequel[:excluded][:token], refresh_token: Sequel[:excluded][:refresh_token], expires_at: Sequel[:excluded][:expires_at]

        # def execute(tuples)
        #   inserted_tuples = with_input_tuples(tuples) do |tuple|
        #     relation.dataset.returning.insert_conflict(
        #       target: [:user_id, :provider],
        #       update: {
        #         token: Sequel[:excluded][:token],
        #         refresh_token: Sequel[:excluded][:refresh_token],
        #         expires_at: Sequel[:excluded][:expires_at]
        #       }
        #     ).insert(tuples)
        #   end
        #   inserted_tuples.flatten(1)
        # end

        # def finalize(tuples, *)
        #   tuples.map { |t| relation.output_schema[t] }
        # end
      end
    end
  end
end

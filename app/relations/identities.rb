# frozen_string_literal: true

module AdhDiary
  module Relations
    class Identities < AdhDiary::DB::Relation
      UTCTime = Types.Nominal(Time)
        .constructor { |time| time.utc.to_i }
        .meta(
          read: Types.Nominal(Time)
          .constructor { |data| data.is_a?(String) ? Time.parse(data).utc : Time.at(data, in: "UTC") }
        )

      schema :identities, infer: true do
        attribute :expires_at, UTCTime

        associations do
          belongs_to :user
        end
      end
    end
  end
end

# frozen_string_literal: true

module AdhDiary
  module Relations
    class Entries < AdhDiary::DB::Relation
      use :pagination
      per_page 10
      schema :entries, infer: true do
        associations do
          belongs_to :account
          belongs_to :medication_schedule
          has_one :medication, through: :medication_schedules
        end
      end

      def report(name, date_format)
        select {
          [
            function(:to_char, date, date_format).as(name),
            function(:array_agg, date).order(date).as(:dates),
            function(:array_agg, date).order(date).sql_subscript(1).as(:from),
            function(:array_agg, date).order(date.desc).sql_subscript(1).as(:to),
            integer.cast(integer.round(float.avg(attention), 0)).as(:attention),
            integer.cast(integer.round(float.avg(organisation), 0)).as(:organisation),
            integer.cast(integer.round(float.avg(mood_swings), 0)).as(:mood_swings),
            integer.cast(integer.round(float.avg(stress_sensitivity), 0)).as(:stress_sensitivity),
            integer.cast(integer.round(float.avg(irritability), 0)).as(:irritability),
            integer.cast(integer.round(float.avg(restlessness), 0)).as(:restlessness),
            integer.cast(integer.round(float.avg(impulsivity), 0)).as(:impulsivity),
            string.string_agg(string.nullif(side_effects, ""), ",").as(:side_effects),
            array.array_agg(blood_pressure).order(:date).as(:blood_pressure),
            array.array_remove(array.array_agg(weight).order(date.desc), nil).sql_subscript(1).as(:weight),
            array.array_agg(string.concat(:name, " ", :morning, " mg")).distinct.as(:medication)

          ]
        }.left_join(:medications)
          .group { name }
          .order(name)
          .where(entries[:account_id].is(current_account.id))
      end
    end
  end
end

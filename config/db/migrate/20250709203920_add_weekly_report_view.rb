# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    create_or_replace_view(
      :weekly_reports,
      ROM::SQL.current_gateway[:entries].select {
        [
          entries[:user_id].as(:user_id),
          to_char(:date, 'IYYY-"W"IW').as(:week),
          array_agg(:date).order(:date).sql_subscript(1).as("from"),
          array_agg(:date).order(Sequel.desc(:date)).sql_subscript(1).as("to"),
          round(avg(:attention)).cast(:integer).as(:attention),
          round(avg(:organisation)).cast(:integer).as(:organisation),
          round(avg(:mood_swings)).cast(:integer).as(:mood_swings),
          round(avg(:stress_sensitivity)).cast(:integer).as(:stress_sensitivity),
          round(avg(:irritability)).cast(:integer).as(:irritability),
          round(avg(:restlessness)).cast(:integer).as(:restlessness),
          round(avg(:impulsivity)).cast(:integer).as(:impulsivity),
          string_agg(nullif(:side_effects, ""), ",").as(:side_effects),
          array_agg(:blood_pressure).order(:date).as(:blood_pressure),
          array_agg(:weight).order(:date).sql_subscript(1).as("weight"),
          array_agg(concat(:name, " ", :morning, "mg")).distinct.as(:medication)
        ]
      }.group_by { [to_char(:date, 'IYYY-"W"IW'), entries[:user_id]] }
          .order(:week)
          .left_join(:medication_schedules, id: :medication_schedule_id)
          .left_join(:medications, id: :medication_id)
    )
  end

  down do
    drop_view(:weekly_reports)
    create_or_replace_view(
      :weekly_reports,
      ROM::SQL.current_gateway[:entries].select {
        [
          entries[:user_id].as(:user_id),
          to_char(:date, 'IYYY-"W"IW').as(:week),
          min(date).as(:from),
          max(date).as(:to),
          round(avg(attention)).cast(:integer).as(:attention),
          round(avg(organisation)).cast(:integer).as(:organisation),
          round(avg(mood_swings)).cast(:integer).as(:mood_swings),
          round(avg(stress_sensitivity)).cast(:integer).as(:stress_sensitivity),
          round(avg(irritability)).cast(:integer).as(:irritability),
          round(avg(restlessness)).cast(:integer).as(:restlessness),
          round(avg(impulsivity)).cast(:integer).as(:impulsivity),

          string_agg(nullif(:side_effects, ""), ",").as(:side_effects),
          array_agg(:blood_pressure).order(:date).as(:blood_pressure),
          array_agg(:weight).order(:date).sql_subscript(1).as("weight"),

          array_agg(
            concat(
              medications[:name], " ",
              medication_schedules[:morning], "-",
              medication_schedules[:noon], "-",
              medication_schedules[:evening], "-",
              medication_schedules[:before_bed]
            )
          ).order(:date).as(:medication)

        ]
      }
              .left_join(:medication_schedules, id: :medication_schedule_id).left_join(:medications, id: :medication_id)
              .group { [to_char(:date, 'IYYY-"W"IW'), entries[:user_id], :date] }
    )
  end
end

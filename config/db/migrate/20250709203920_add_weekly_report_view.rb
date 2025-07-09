# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  up do
    sql = <<~SQL
      SELECT
        `entries`.`user_id`,
        STRFTIME('%Y-W%W', `entries`.`date`) AS 'week',
        MIN(`entries`.`date`) AS 'from',
        MAX(`entries`.`date`) AS 'to',
        CAST(
          ROUND(
            AVG(`entries`.`attention`)
          ) AS INTEGER
        ) AS 'attention',
        CAST(
          ROUND(
            AVG(`entries`.`organisation`)
          ) AS INTEGER
        ) AS 'organisation',
        CAST(
          ROUND(
            AVG(`entries`.`mood_swings`)
          ) AS INTEGER
        ) AS 'mood_swings',
        CAST(
          ROUND(
            AVG(`entries`.`stress_sensitivity`)
          ) AS INTEGER
        ) AS 'stress_sensitivity',
        CAST(
          ROUND(
            AVG(`entries`.`irritability`)
          ) AS INTEGER
        ) AS 'irritability',
        CAST(
          ROUND(
            AVG(`entries`.`restlessness`)
          ) AS INTEGER
        ) AS 'restlessness',
        CAST(
          ROUND(
            AVG(`entries`.`impulsivity`)
          ) AS INTEGER
        ) AS 'impulsivity',
        GROUP_CONCAT(
          NULLIF(`entries`.`side_effects`, '')
        ) AS 'side_effects',
        GROUP_CONCAT(`entries`.`blood_pressure`) AS 'blood_pressure',
        JSON_EXTRACT(
          JSON_GROUP_ARRAY(`entries`.`weight`),
          '$[#-1]'
        ) AS 'weight',
        REPLACE(
          GROUP_CONCAT(
            DISTINCT CONCAT(
              `medications`.`name`,
              ' ',
              CAST (
                `medication_schedules`.`morning` AS INTEGER
              ),
              '-',
              CAST (
                `medication_schedules`.`noon` AS INTEGER
              ),
              '-',
              CAST (
                `medication_schedules`.`evening` AS INTEGER
              ),
              '-',
              CAST (
                `medication_schedules`.`before_bed` AS INTEGER
              )
            )
          ),
          ',',
          ', '
        ) AS 'medication'
      FROM
        `entries`
        LEFT JOIN `medication_schedules` ON (
          `entries`.`medication_schedule_id` = `medication_schedules`.`id`
        )
        LEFT JOIN `medications` ON (
          `medication_schedules`.`medication_id` = `medications`.`id`
        )
      GROUP BY
        `week`
      ORDER BY
        `entries`.`date`
    SQL
    create_or_replace_view(
      :weekly_reports,
      sql
    )
  end

  down do
    drop_view :weekly_reports
  end
end

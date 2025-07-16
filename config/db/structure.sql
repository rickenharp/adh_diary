CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `users`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_salt` varchar(255) NOT NULL
  ,
  `locale` varchar(255) DEFAULT('en')
);
CREATE UNIQUE INDEX `users_email_index` ON `users`(`email`);
CREATE TABLE `medications`(
  `id` integer NOT NULL PRIMARY KEY,
  `name` varchar(255) NOT NULL UNIQUE
);
CREATE TABLE `medication_schedules`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `medication_id` integer REFERENCES `medications`,
  `user_id` integer REFERENCES `users`,
  `morning` double precision DEFAULT(0),
  `noon` double precision DEFAULT(0),
  `evening` double precision DEFAULT(0),
  `before_bed` double precision DEFAULT(0),
  `notes` varchar(255)
);
CREATE TABLE `entries`(
  `id` INTEGER DEFAULT(NULL) NOT NULL PRIMARY KEY AUTOINCREMENT,
  `date` date DEFAULT(NULL) NOT NULL UNIQUE,
  `attention` INTEGER DEFAULT(NULL) NOT NULL,
  `organisation` INTEGER DEFAULT(NULL) NOT NULL,
  `mood_swings` INTEGER DEFAULT(NULL) NOT NULL,
  `stress_sensitivity` INTEGER DEFAULT(NULL) NOT NULL,
  `irritability` INTEGER DEFAULT(NULL) NOT NULL,
  `restlessness` INTEGER DEFAULT(NULL) NOT NULL,
  `impulsivity` INTEGER DEFAULT(NULL) NOT NULL,
  `side_effects` varchar(255) DEFAULT(NULL) NULL,
  `blood_pressure` varchar(255) DEFAULT(NULL) NULL,
  `weight` double precision DEFAULT(NULL) NOT NULL,
  `user_id` INTEGER DEFAULT(NULL) NULL,
  `medication_schedule_id` INTEGER DEFAULT(NULL) NOT NULL,
  FOREIGN KEY(`medication_schedule_id`) REFERENCES `medication_schedules` ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY(`user_id`) REFERENCES `users` ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX `entries_date_index` ON `entries`(`date`);
CREATE VIEW `weekly_reports` AS SELECT
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
/* weekly_reports(user_id,week,"from","to",attention,organisation,mood_swings,stress_sensitivity,irritability,restlessness,impulsivity,side_effects,blood_pressure,weight,medication) */;
CREATE TABLE `identities`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `user_id` integer REFERENCES `users`,
  `provider` varchar(255),
  `uid` varchar(255),
  `token` varchar(255),
  `refresh_token` varchar(255),
  `expires_at` timestamp
);
CREATE UNIQUE INDEX `identities_user_id_provider_index` ON `identities`(
  `user_id`,
  `provider`
);
INSERT INTO schema_migrations (filename) VALUES
('20250609113142_create_entries.rb'),
('20250611091712_create_users.rb'),
('20250619131219_add_user_to_entries.rb'),
('20250619154513_add_dose_to_entry.rb'),
('20250619160833_add_medication_to_entry.rb'),
('20250620154450_make_email_unique.rb'),
('20250707111925_add_medications.rb'),
('20250707162552_make_user_medications_foreign_key.rb'),
('20250708121437_add_medication_schedule.rb'),
('20250709152754_switch_entries_to_medication_schedule.rb'),
('20250709203920_add_weekly_report_view.rb'),
('20250710102932_add_locale_to_user.rb'),
('20250715143059_add_identities.rb');

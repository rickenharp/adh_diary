CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `users`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_salt` varchar(255) NOT NULL
);
CREATE UNIQUE INDEX `users_email_index` ON `users`(`email`);
CREATE TABLE `medications`(
  `id` integer NOT NULL PRIMARY KEY,
  `name` varchar(255) NOT NULL UNIQUE
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
  `dose` INTEGER DEFAULT(0) NULL,
  `medication_id` INTEGER DEFAULT(NULL) NOT NULL,
  FOREIGN KEY(`medication_id`) REFERENCES `medications` ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY(`user_id`) REFERENCES `users` ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX `entries_date_index` ON `entries`(`date`);
INSERT INTO schema_migrations (filename) VALUES
('20250609113142_create_entries.rb'),
('20250611091712_create_users.rb'),
('20250619131219_add_user_to_entries.rb'),
('20250619154513_add_dose_to_entry.rb'),
('20250619160833_add_medication_to_entry.rb'),
('20250620154450_make_email_unique.rb'),
('20250707111925_add_medications.rb'),
('20250707162552_make_user_medications_foreign_key.rb');

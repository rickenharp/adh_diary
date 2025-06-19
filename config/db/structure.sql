CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `entries`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `date` date NOT NULL UNIQUE,
  `attention` integer NOT NULL,
  `organisation` integer NOT NULL,
  `mood_swings` integer NOT NULL,
  `stress_sensitivity` integer NOT NULL,
  `irritability` integer NOT NULL,
  `restlessness` integer NOT NULL,
  `impulsivity` integer NOT NULL,
  `side_effects` varchar(255),
  `blood_pressure` varchar(255),
  `weight` double precision NOT NULL
);
CREATE INDEX `entries_date_index` ON `entries`(`date`);
CREATE TABLE `users`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_salt` varchar(255) NOT NULL
);
INSERT INTO schema_migrations (filename) VALUES
('20250609113142_create_entries.rb'),
('20250611091712_create_users.rb');

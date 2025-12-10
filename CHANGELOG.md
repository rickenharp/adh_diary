# Changelog

## [1.3.2](https://github.com/rickenharp/adh_diary/compare/v1.3.1...v1.3.2) (2025-12-10)


### Bug Fixes

* allow blood pressure with null values ([f58aa8c](https://github.com/rickenharp/adh_diary/commit/f58aa8ce12b4b60b0eeaf0db0010bf234d4e4892))
* allow weights with null values ([ee3f21f](https://github.com/rickenharp/adh_diary/commit/ee3f21fb38a063048703e3164649587db6450364))

## [1.3.1](https://github.com/rickenharp/adh_diary/compare/v1.3.0...v1.3.1) (2025-11-13)


### Bug Fixes

* update routes to use new resource routes ([af89266](https://github.com/rickenharp/adh_diary/commit/af89266605a2f21bac4e11c0ced1ca07440f8972))

## [1.3.0](https://github.com/rickenharp/adh_diary/compare/v1.2.0...v1.3.0) (2025-10-11)


### Features

* switch to rodauth for authentication ([d82b12a](https://github.com/rickenharp/adh_diary/commit/d82b12add99903d3969aee3a543fb68b66db1621))

## [1.2.0](https://github.com/rickenharp/adh_diary/compare/v1.1.0...v1.2.0) (2025-09-27)


### Features

* limit pagination to max of 5 links ([ad9a22f](https://github.com/rickenharp/adh_diary/commit/ad9a22fee82dc529f8770ed22a44bc147a1be749))

## [1.1.0](https://github.com/rickenharp/adh_diary/compare/v1.0.1...v1.1.0) (2025-09-27)


### Features

* add automatic update of collations ([fa13e3f](https://github.com/rickenharp/adh_diary/commit/fa13e3f67b4a08dc1bf05651884b88fa0047a821)), closes [#110](https://github.com/rickenharp/adh_diary/issues/110)
* remove sqlite ([5e589fe](https://github.com/rickenharp/adh_diary/commit/5e589fe63ec3c4f0e67dfc5f0684cb99c37983e9)), closes [#109](https://github.com/rickenharp/adh_diary/issues/109)

## [1.0.1](https://github.com/rickenharp/adh_diary/compare/v1.0.0...v1.0.1) (2025-08-11)


### Bug Fixes

* add form_action csp settings ([acaec08](https://github.com/rickenharp/adh_diary/commit/acaec08439960426abfb4baa2352589de58d9870))

## [1.0.0](https://github.com/rickenharp/adh_diary/compare/v0.7.1...v1.0.0) (2025-07-31)


### ⚠ BREAKING CHANGES

* the underlying database engine has changed

### Features

* switching to postgresql ([3e981ff](https://github.com/rickenharp/adh_diary/commit/3e981ff48d22a9471d28f168c7bd2e57b7da8f14))

## [0.7.1](https://github.com/rickenharp/adh_diary/compare/v0.7.0...v0.7.1) (2025-07-25)


### Bug Fixes

* better handling of time ([926fa0a](https://github.com/rickenharp/adh_diary/commit/926fa0ac2b7ecc87cfd65b504d2583d83b6f5a0f))

## [0.7.0](https://github.com/rickenharp/adh_diary/compare/v0.6.2...v0.7.0) (2025-07-23)


### Features

* deployment is now a setting ([ca43d94](https://github.com/rickenharp/adh_diary/commit/ca43d94931e8653c08953ba3905c31b6e5bb537b))
* make host_name configurable ([681fa4b](https://github.com/rickenharp/adh_diary/commit/681fa4b4073eb4d34b9e5331ff8d575a92346c74))


### Bug Fixes

* handle token refresh correctly ([d8a9790](https://github.com/rickenharp/adh_diary/commit/d8a9790fce71017c9dd0116efc9f0b1cc27eb8d2))

## [0.6.2](https://github.com/rickenharp/adh_diary/compare/v0.6.1...v0.6.2) (2025-07-21)


### Bug Fixes

* fix darkmode colorsw ([b701b0c](https://github.com/rickenharp/adh_diary/commit/b701b0c47b939d7c0043407f08916b989d0e0971))
* oauth and Withings API should work now ([9fdbdac](https://github.com/rickenharp/adh_diary/commit/9fdbdac436e1249d4e6e10518ddf2005f8e46ab0))

## [0.6.1](https://github.com/rickenharp/adh_diary/compare/v0.6.0...v0.6.1) (2025-07-21)


### Bug Fixes

* add debug information ([abeb7d4](https://github.com/rickenharp/adh_diary/commit/abeb7d4d0f9e18fae7ff5a2b9cdd98dde9f3ee07))
* error handling for GetMeasurements ([67e1167](https://github.com/rickenharp/adh_diary/commit/67e11677a8c477f9cae38bf377a579349a352071))
* even more fixes ([a36439f](https://github.com/rickenharp/adh_diary/commit/a36439f089c791cd4ca211588de6449103f37a26))
* ffs ([94059fd](https://github.com/rickenharp/adh_diary/commit/94059fd9561be303df60824d57f9a232bdf35421))
* fix debug information ([26a0218](https://github.com/rickenharp/adh_diary/commit/26a0218ce290fd91a038eaf23c8e044c76571d00))
* **i18n:** add soft hyphens in german translation ([164a615](https://github.com/rickenharp/adh_diary/commit/164a6156b4e6d1afd360f7eae3191e61d7adbbe4))
* more fixes ([63c8f44](https://github.com/rickenharp/adh_diary/commit/63c8f443bd7b96f34e8b0f28f6a226e46bf05aca))
* set full_host in production ([4ffeaef](https://github.com/rickenharp/adh_diary/commit/4ffeaefef55d76ad3c273360a4ec08757bb96302))
* shorten wait interval ([dc2b873](https://github.com/rickenharp/adh_diary/commit/dc2b8734eb46d5a8cc19a622d44d351a285c91d6))
* switch log level to debug in debug mode ([90a3da1](https://github.com/rickenharp/adh_diary/commit/90a3da129aceecee805ffc0bf3ff2bb458b81679))

## [0.6.0](https://github.com/rickenharp/adh_diary/compare/v0.5.0...v0.6.0) (2025-07-20)


### Features

* add Withings integration ([d13f135](https://github.com/rickenharp/adh_diary/commit/d13f1352f5bea520ee0157b6859c70cec76f3bc2))

## [0.5.0](https://github.com/rickenharp/adh_diary/compare/v0.4.1...v0.5.0) (2025-07-14)


### Features

* add bulk pdf export ([1479465](https://github.com/rickenharp/adh_diary/commit/14794656d636d475d3b412996c1c7b7b19a0ba75))
* add i18n to flash notifications ([061fbaa](https://github.com/rickenharp/adh_diary/commit/061fbaaa1eee42e909cddf838dda708a7ae5b135))
* add MIT license ([c2c8b9b](https://github.com/rickenharp/adh_diary/commit/c2c8b9b257d51d98e4efd81e2cc180dfb793ad89))

## [0.4.1](https://github.com/rickenharp/adh_diary/compare/v0.4.0...v0.4.1) (2025-07-13)


### Bug Fixes

* add missing translations ([741833f](https://github.com/rickenharp/adh_diary/commit/741833f87217b514ff919989925998a6751ecd7e))

## [0.4.0](https://github.com/rickenharp/adh_diary/compare/v0.3.0...v0.4.0) (2025-07-13)


### Features

* add pdf report generation ([eae9ce8](https://github.com/rickenharp/adh_diary/commit/eae9ce807973c9b3455aaa110868a054051f56c1)), closes [#37](https://github.com/rickenharp/adh_diary/issues/37)

## [0.3.0](https://github.com/rickenharp/adh_diary/compare/v0.2.1...v0.3.0) (2025-07-11)


### Features

* actually switch to medication_schedule ([1110f19](https://github.com/rickenharp/adh_diary/commit/1110f19288152c982957b3897ef8e839956c15c5))
* add i18n ([10d9219](https://github.com/rickenharp/adh_diary/commit/10d9219a41649642fb89d807d12c0ac8a789af1d))
* add medication schedule deletion ([c4c67e0](https://github.com/rickenharp/adh_diary/commit/c4c67e026aff9cf0a8e99ea45a431bf8509ef50e))
* add medication schedule index ([15ce13b](https://github.com/rickenharp/adh_diary/commit/15ce13b624deadc04b746e15812d072275e1ee9d))
* add most of the medication schedule CRUD ([075677e](https://github.com/rickenharp/adh_diary/commit/075677eef05e299a974a36cf086b44a1a3916882))
* extract medication to own table ([65c47f1](https://github.com/rickenharp/adh_diary/commit/65c47f184f18799bb68ad86c0650c8d78d7bde07))


### Bug Fixes

* scope database queries to logged in user ([78280fb](https://github.com/rickenharp/adh_diary/commit/78280fbe3f18ef7a05019027de0d5cebf143bc40))

## [0.2.1](https://github.com/rickenharp/adh_diary/compare/v0.2.0...v0.2.1) (2025-07-05)


### Bug Fixes

* reorder fields in entry table ([#24](https://github.com/rickenharp/adh_diary/issues/24)) ([8f3f22b](https://github.com/rickenharp/adh_diary/commit/8f3f22bc1a95c16c0df299fd1b72208b20ae1804)), closes [#23](https://github.com/rickenharp/adh_diary/issues/23)

## [0.2.0](https://github.com/rickenharp/adh_diary/compare/v0.1.0...v0.2.0) (2025-06-23)


### Features

* add pagination to entries ([#22](https://github.com/rickenharp/adh_diary/issues/22)) ([91074f5](https://github.com/rickenharp/adh_diary/commit/91074f502287d95f478d28b637128ef7f0efd3de)), closes [#17](https://github.com/rickenharp/adh_diary/issues/17)
* **report:** implement report feature ([#20](https://github.com/rickenharp/adh_diary/issues/20)) ([5f52b92](https://github.com/rickenharp/adh_diary/commit/5f52b924b83a329069996349706405130e40db14)), closes [#19](https://github.com/rickenharp/adh_diary/issues/19)

## [0.1.0](https://github.com/rickenharp/adh_diary/compare/v0.0.2...v0.1.0) (2025-06-22)


### Features

* **entries:** remember last used medication and dose ([f693ff5](https://github.com/rickenharp/adh_diary/commit/f693ff53dc3de299dfaa3ee9e81c8add1c2a9705))

## [0.0.2](https://github.com/rickenharp/adh_diary/compare/v0.0.1...v0.0.2) (2025-06-21)


### Miscellaneous Chores

* release 0.0.2 ([8d0e27d](https://github.com/rickenharp/adh_diary/commit/8d0e27da52846b3bf5a7abc0b12a4c79e066861b))

## 0.0.1 (2025-06-21)


### Features

* add authentication ([f120b97](https://github.com/rickenharp/adh_diary/commit/f120b975c9d22fbeb88824978bf298c95e854058))
* add CRU functionality ([723c52f](https://github.com/rickenharp/adh_diary/commit/723c52fd14a8bc6d938a5252ba0f38b0b35a1309))
* add entry creation ([57834e9](https://github.com/rickenharp/adh_diary/commit/57834e99a5c42a2c7aa19b37a973aa99aed00524))
* show entries from the database ([0a092bc](https://github.com/rickenharp/adh_diary/commit/0a092bc8368e9859f811c7463724a9069b6e5ca4))


### Miscellaneous Chores

* release 0.0.1 ([738aeec](https://github.com/rickenharp/adh_diary/commit/738aeec6c3f7274d47ed9ff91ab343c6df5e0bc1))

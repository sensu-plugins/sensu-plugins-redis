# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Our CHANGELOG Guidelines](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md).
Which is based on [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

### Added
- Updated asset build targets to support centos6
- Removed centos from bonsai asset definition

### Added
- Travis build automation to generate Sensu Asset tarballs that can be used n conjunction with Sensu provided ruby runtime assets and the Bonsai Asset Index

## [4.1.0] - 2019-05-06
### Added
- `metrics-redis-keys.rb` metric about the number of keys matching a given pattern (@ydkn)

## [4.0.0] - 2019-04-24
### Breaking Changes
- dropping ruby support for `< 2.3` as they are EOL (@majormoses)
- bump `sensu-plugin` dependency from `~> 1.2` to `~> 4.0` you can read the changelog entries for [4.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#400---2018-02-17), [3.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#300---2018-12-04), and [2.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29) (@majormoses)

## [3.1.1] - 2019-04-02
### Fixed
- metrics-redis-graphite.rb: update list of skip keys in `SKIP_KEYS_REGEX` (@boutetnico)

## [3.1.0] - 2019-03-04
### Added
- added a `--transport (redis|rediss)` option to allow connecting to redis via TLS (@mindriot88)

### Changed
- metrics-redis-graphite.rb: update list of skip keys in `SKIP_KEYS_REGEX` (@boutetnico)

### Removed
- commented out integration testing for now :sadpanda: as it appears there was some change to redis and our bootstrap is not working the way it was originally used. The disable should be temp and when someone has the time to work through it we should be good to bring this back in. (@majormoses)
- removed testing from tagged releases for EOL versions of ruby, this should still test them on push to master but this reduces the ammount of time that it takes to make a release (@majormoses)

## [3.0.1] - 2018-03-28
### Security
- updated yard dependency to `~> 0.9.11` per: https://nvd.nist.gov/vuln/detail/CVE-2017-17042 (@majormoses)

## [3.0.0] - 2018-03-17
### Security
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@majormoses)

### Breaking Changes
- removed ruby `< 2.1` support (@majormoses)

### Changed
- appeased the cops (@majormoses)

## [2.4.0] - 2018-03-14
### Added
- check-redis-connections-available.rb: checks the number of connections available (@nishiki)
## [2.3.2] - 2017-12-21
### Fixed
- locked `development_dependency` of `mixlib-shellout` on to fix ruby 2.1 support (@majormoses)

## [2.3.1] - 2017-12-08
### Fixed
- ensure that `--socket` option is properly parsed and takes precedence over `--host`/`--port` (@mbyczkowski)

## [2.3.0] - 2017-11-12
### Added
- metrics-redis-llen.rb - Support passing multiple comma separated keys (@Evesy)
- Integration tests (@evesy)

## [2.2.2] - 2017-11-11
### Fixed
- check-redis-key.rb: Fix the wording of the check output on warning/critical states (@evesy)

## [2.2.1] - 2017-09-14
### Fixed
- ensure that `--timeout` option is an integer (@empyrean987)

### Changed
- update location of our CHANGELOG guidelines (@majormoses)

## [2.2.0] - 2017-09-09
### Added
- All check scripts have a new option of `--timeout` (@empyrean987)

## [2.1.0] - 2017-08-17
### Added
- metrics-redis-llen.rb config option to choose db (@athal7)

### Fixed
- check-redis-list-length.rb socket option referenced correctly (@athal7)
- metrics-redis-llen.rb socket option referenced correctly (@athal7)

## [2.0.1] - 2017-08-15
### Fixed
- metrics-redis-graphite.rb, metrics-redis-llen.rb: rename short option for `--scheme` from `-s` to `-S` to resolve conflict. (@stuwil)

## [2.0.0] - 2017-07-23
### Breaking Changes
- Standardised exit status for Redis connection failures/timeouts to Unknown, with the exception of 'check-redis-ping' which will exit Critical (@Evesy)
- check-redis-memory-percentage.rb, check-redis-memory.rb: removed redundant `crit_conn` (@Evesy)

### Added
- Config option to override the default exit status on Redis connection failures/timeouts

### Added
- ruby 2.4 testing on travis (@majormoses)

## [1.4.0] - 2017-06-24
### Added
- check-redis-list-length.rb support more datatypes to check (@nevins-b)

## [1.3.1] - 2017-05-31
### Fixed
- metrics-redis-graphite: fix commandstats output (@boutetnico)

## [1.3.0] - 2017-05-31
### Added
- Added option to connect to Redis via Unix sockets. (@mbyczkowski)

## [1.2.2] - 2017-05-31
### Fixed
- metrics-redis-graphite: fix skipkeys option not accepting any argument (@boutetnico)

## [1.2.1] - 2017-05-14
### Fixed
- Updated list of SKIP_KEYS_REGEX in metrics-redis-graphite.rb per #22 and added an option to override the list of keys to allow users to deal with changes without the need of a release (@majormoses)

### Added
- Added option to override SKIP_KEYS_REGEX via option. (@majormoses)
## [1.2.0] - 2017-05-09
### Changed
- check-redis-memory-percentage: Handle case where maxmemory is 0 (@stevenviola)

## [1.1.1] - 2017-05-05
### Fixed
- updated gemspec to avoid deprecation warnings in redis client for Fixnum

## [1.1.0] - 2017-05-02
### Added
- metrics-redis-graphite: add commandstats metrics (@PhilGuay)
### Changed
- check-redis-memory-percentage use maxmemory property if available (@andyroyle)
- check-redis-memory-percentage fix float conversion bug (@andyroyle)
- check-redis-slave-status: do not throw error if server is master (@stevenviola)

## [1.0.0] - 2016-05-23
### Added
- Ruby 2.3.0 support

### Removed
- Ruby 1.9.3 support

### Fixed
- check-redis-memory.rb, check-redis-memory-percentage.rb: fix message output

### Changed
- Update to rubocop 0.40 and cleanup

## [0.1.0] - 2016-03-22
### Added
- added support for memory check using percentage %

## [0.0.4] - 2015-08-04
### Changed
- general clean no code changes

## [0.0.3] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.2] - 2015-07-05
### Added
- Add check for existance of Redis keys

### Fixed
- Fixed the gemspec to properly install the plugins to the embedded sensu bin dir

## 0.0.1 - 2015-05-31
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/4.1.0...HEAD
[4.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/4.0.0...4.0.0
[4.0.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/3.1.1...4.0.0
[3.1.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/3.1.0...3.1.1
[3.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/3.0.1...3.1.0
[3.0.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.4.0...3.0.0
[2.4.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.3.2...2.4.0
[2.3.2]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.3.1...2.3.2
[2.3.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.3.0...2.3.1
[2.3.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.2.2...2.3.0
[2.2.2]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.2.1...2.2.2
[2.2.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.2.0...2.2.1
[2.2.0]:https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.0.1...2.1.0
[2.0.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.4.0...2.0.0
[1.4.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.3.1...1.4.0
[1.3.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.3.0...1.3.1
[1.3.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.2.2...1.3.0
[1.2.2]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.2.1...1.2.2
[1.2.1]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.4...0.1.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.1...0.0.2

#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.1.0...HEAD
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.4...0.1.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-redis/compare/0.0.1...0.0.2

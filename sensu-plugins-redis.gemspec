# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'

require_relative 'lib/sensu-plugins-redis'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.authors                = ['Sensu-Plugins and contributors']

  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides native Redis instrumentation
                              for monitoring and metrics collection, including:
                              service health, database connectivity, replication
                              status, `INFO` metrics, key counts, list lengths,
                              and more.'
  s.email                  = '<sensu-users@googlegroups.com>'
  s.files                  = Dir.glob('{bin,lib}/**/*.rb') + %w[LICENSE README.md CHANGELOG.md]
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.homepage               = 'https://github.com/sensu-plugins/sensu-plugins-redis'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer' => 'sensu-plugin',
                               'development_status' => 'active',
                               'production_status' => 'unstable - testing recommended',
                               'release_draft' => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-plugins-redis'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.3.0'

  s.summary                = 'Sensu plugins for working with redis'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsRedis::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 4.0'

  s.add_runtime_dependency 'redis',        '>= 3.3', '< 5.0'

  s.add_development_dependency 'bundler',                   '~> 2.1'
  s.add_development_dependency 'github-markup',             '~> 3.0'
  s.add_development_dependency 'kitchen-docker',            '~> 2.6'
  s.add_development_dependency 'kitchen-localhost',         '~> 0.3'
  # locked to keep ruby 2.1 support, this is pulled in by test-kitchen
  s.add_development_dependency 'mixlib-shellout',           ['< 2.3.0', '~> 2.2']
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 13.0'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rspec',                     '~> 3.1'
  s.add_development_dependency 'rubocop',                   '~> 0.79.0'
  s.add_development_dependency 'serverspec',                '~> 2.36.1'
  s.add_development_dependency 'test-kitchen',              '~> 1.16.0'
  s.add_development_dependency 'yard',                      '~> 0.9.11'
end

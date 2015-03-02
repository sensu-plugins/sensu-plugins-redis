## Sensu-Plugins-redis

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-redis.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-redis)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-redis.svg)](http://badge.fury.io/rb/sensu-plugins-redis)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-redis.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-redis)

## Functionality

## Files
 * bin/check-redis-info
 * bin/check-redis-list-length
 * bin/check-redis-memory
 * bin/check-redis-ping
 * bin/check-redis-slave-status
 * bin/extension-redis-output
 * bin/metrics-redis-graphite
 * bin/metrics-redis-llen

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-redis -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-redis`

#### Bundler

Add *sensu-plugins-disk-checks* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-redis' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-redis' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

## Notes

[1]:[https://travis-ci.org/sensu-plugins/sensu-plugins-redis]
[2]:[http://badge.fury.io/rb/sensu-plugins-redis]
[3]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis]
[4]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis]
[5]:[https://gemnasium.com/sensu-plugins/sensu-plugins-redis]

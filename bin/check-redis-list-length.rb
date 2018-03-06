#!/usr/bin/env ruby
#
# Checks number of items in a Redis list key
# ===
#
# Depends on redis gem
# gem install redis
#
# Copyright (c) 2013, Piavlo <lolitushka@gmail.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/check/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisListLengthCheck < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  option :warn,
         short: '-w COUNT',
         long: '--warning COUNT',
         description: 'COUNT warning threshold for number of items in Redis list key',
         proc: proc(&:to_i),
         required: true

  option :crit,
         short: '-c COUNT',
         long: '--critical COUNT',
         description: 'COUNT critical threshold for number of items in Redis list key',
         proc: proc(&:to_i),
         required: true

  option :key,
         short: '-k KEY',
         long: '--key KEY',
         description: 'Redis list KEY to check',
         required: true

  def run
    redis = Redis.new(default_redis_options)

    length =  case redis.type(config[:key])
              when 'hash'
                redis.hlen(config[:key])
              when 'set'
                redis.scard(config[:key])
              else
                redis.llen(config[:key])
              end

    if length >= config[:crit]
      critical "Redis list #{config[:key]} length is above the CRITICAL limit: #{length} length / #{config[:crit]} limit"
    elsif length >= config[:warn]
      warning "Redis list #{config[:key]} length is above the WARNING limit: #{length} length / #{config[:warn]} limit"
    else
      ok "Redis list #{config[:key]} length (#{length}) is below thresholds"
    end
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

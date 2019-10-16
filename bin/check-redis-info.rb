#!/usr/bin/env ruby
# frozen_string_literal: false

#
# Checks checks variables from redis INFO http://redis.io/commands/INFO
#
# ===
#
# Depends on redis gem
# gem install redis
#
# ===
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.
#
# Heavily inspired in check-redis-slave-status.rb
# https://github.com/sensu/sensu-community-plugins/blob/master/plugins/redis/check-redis-slave-status.rb
#

require 'sensu-plugin/check/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisSlaveCheck < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  option :redis_info_key,
         short: '-K VALUE',
         long: '--redis-info-key KEY',
         description: 'Redis info key to monitor',
         required: false,
         default: 'role'

  option :redis_info_value,
         short: '-V VALUE',
         long: '--redis-info-key-value VALUE',
         description: 'Redis info key value to trigger alarm',
         required: false,
         default: 'master'

  option :warn,
         short: '-w COUNT',
         long: '--warning COUNT',
         description: 'COUNT warning threshold for number of items in Redis list key',
         proc: proc(&:to_i),
         required: false

  option :crit,
         short: '-c COUNT',
         long: '--critical COUNT',
         description: 'COUNT critical threshold for number of items in Redis list key',
         proc: proc(&:to_i),
         required: false

  def run
    redis = Redis.new(default_redis_options)


    if config[:redis_info_value] != "master"
      if redis.info.fetch(config[:redis_info_key].to_s) == config[:redis_info_value].to_s
        ok "Redis #{config[:redis_info_key]} is #{config[:redis_info_value]}"
      else
        critical "Redis #{config[:redis_info_key]} is #{redis.info.fetch(config[:redis_info_key].to_s)}!"
      end

    end

    length =  case redis.type(config[:key])
              when 'hash'
                redis.hlen(config[:key])
              when 'set'
                redis.scard(config[:key])
              else
                redis.llen(config[:key])
              end
    if length >= config[:crit]
      critical "Redis info #{config[:key]} length is above the CRITICAL limit: #{length} length / #{config[:crit]} limit"
    elsif length >= config[:warn]
      warning "Redis info #{config[:key]} length is above the WARNING limit: #{length} length / #{config[:warn]} limit"
    else
      ok "Redis info #{config[:key]} length (#{length}) is below thresholds"
    end

  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end


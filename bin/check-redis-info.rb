#!/usr/bin/env ruby
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

  def run
    redis = Redis.new(default_redis_options)

    if redis.info.fetch(config[:redis_info_key].to_s) == config[:redis_info_value].to_s
      ok "Redis #{config[:redis_info_key]} is #{config[:redis_info_value]}"
    else
      critical "Redis #{config[:redis_info_key]} is #{redis.info.fetch(config[:redis_info_key].to_s)}!"
    end
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

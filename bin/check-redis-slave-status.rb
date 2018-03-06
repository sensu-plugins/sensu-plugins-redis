#!/usr/bin/env ruby
#
# Checks Redis Slave Replication

require 'sensu-plugin/check/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisSlaveCheck < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  def run
    redis = Redis.new(default_redis_options)

    if redis.info.fetch('role') == 'master'
      ok 'This redis server is master'
    elsif redis.info.fetch('master_link_status') == 'up'
      ok 'The redis master links status is up!'
    else
      msg = ''
      msg += "The redis master link status to: #{redis.info.fetch('master_host')} is down!"
      msg += " It has been down for #{redis.info.fetch('master_link_down_since_seconds')}."
      critical msg
    end
  rescue KeyError
    critical "Redis server on #{redis_endpoint} is not master and does not have master_link_status"
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

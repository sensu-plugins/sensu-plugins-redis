#!/usr/bin/env ruby
#
# Checks Redis Slave Replication

require 'sensu-plugin/check/cli'
require 'redis'

class RedisSlaveCheck < Sensu::Plugin::Check::CLI
  option :host,
         short: '-h HOST',
         long: '--host HOST',
         description: 'Redis Host to connect to',
         required: false,
         default: '127.0.0.1'

  option :port,
         short: '-p PORT',
         long: '--port PORT',
         description: 'Redis Port to connect to',
         proc: proc(&:to_i),
         required: false,
         default: 6379

  option :password,
         short: '-P PASSWORD',
         long: '--password PASSWORD',
         description: 'Redis Password to connect with'

  option :warn_conn,
         long: '--warn-conn-failure',
         boolean: true,
         description: 'Warning instead of critical on connection failure',
         default: false

  def run
    options = { host: config[:host], port: config[:port] }
    options[:password] = config[:password] if config[:password]
    redis = Redis.new(options)

    if redis.info.fetch('master_link_status') == 'up'
      ok 'The redis master links status is up!'
    else
      msg = ''
      msg += "The redis master link status to: #{redis.info.fetch('master_host')} is down!"
      msg += " It has been down for #{redis.info.fetch('master_link_down_since_seconds')}."
      critical msg
    end

  rescue KeyError
    critical "Redis server on #{config[:host]}:#{config[:port]} is master"

  rescue
    message = "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
    if config[:warn_conn]
      warning message
    else
      critical message
    end
  end
end

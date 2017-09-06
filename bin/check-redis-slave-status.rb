#!/usr/bin/env ruby
#
# Checks Redis Slave Replication

require 'sensu-plugin/check/cli'
require 'redis'

class RedisSlaveCheck < Sensu::Plugin::Check::CLI
  option :socket,
         short: '-s SOCKET',
         long: '--socket SOCKET',
         description: 'Redis socket to connect to (overrides Host and Port)',
         required: false

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

  option :conn_failure_status,
         long: '--conn-failure-status EXIT_STATUS',
         description: 'Returns the following exit status for Redis connection failures',
         default: 'unknown',
         in: %w(unknown warning critical)

  option :timeout,
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         description: 'Redis connection timeout',
         required: false,
         default: 5

  def run
    options = if config[:socket]
                { path: socket }
              else
                { host: config[:host], port: config[:port], timeout: config[:timeout] }
              end

    options[:password] = config[:password] if config[:password]
    redis = Redis.new(options)

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
    critical "Redis server on #{config[:host]}:#{config[:port]} is not master and does not have master_link_status"
  rescue
    send(config[:conn_failure_status], "Could not connect to Redis server on #{config[:host]}:#{config[:port]}")
  end
end

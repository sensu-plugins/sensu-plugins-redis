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

    if redis.info.fetch(config[:redis_info_key].to_s) == config[:redis_info_value].to_s
      ok "Redis #{config[:redis_info_key]} is #{config[:redis_info_value]}"
    else
      critical "Redis #{config[:redis_info_key]} is #{redis.info.fetch(config[:redis_info_key].to_s)}!"
    end
  rescue
    send(config[:conn_failure_status], "Could not connect to Redis server on #{config[:host]}:#{config[:port]}")
  end
end

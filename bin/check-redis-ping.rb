#! /usr/bin/env ruby
#  encoding: UTF-8
#   <script name>
#
# DESCRIPTION:
#   Runs Redis ping command to see if Redis is alive
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: redis
#
# USAGE:
#   check-redis-ping.rb -h redis.example.com -p 6380 -P secret
#
# NOTE:
#   Heavily inspired by check-redis-info.rb
#   https://github.com/sensu/sensu-community-plugins/blob/master/plugins/redis/check-redis-info.rb
#
# LICENSE:
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'redis'

class RedisPing < Sensu::Plugin::Check::CLI
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
         default: 'critical',
         in: %w(unknown warning critical)

  option :timeout,
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         description: 'Redis connection timeout',
         required: false,
         default: 5

  def redis_options
    if config[:socket]
      {
        path:     config[:socket],
        password: config[:password]
      }
    else
      {
        host:     config[:host],
        port:     config[:port],
        password: config[:password],
        timeout:  config[:timeout]
      }
    end
  end

  def run
    if Redis.new(redis_options).ping == 'PONG'
      ok 'Redis is alive'
    else
      critical 'Redis did not respond to the ping command'
    end
  rescue
    send(config[:conn_failure_status], "Could not connect to Redis server on #{config[:host]}:#{config[:port]}")
  end
end

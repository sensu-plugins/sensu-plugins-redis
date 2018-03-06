#! /usr/bin/env ruby

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
require_relative '../lib/redis_client_options'

class RedisPing < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  def run
    if Redis.new(default_redis_options).ping == 'PONG'
      ok 'Redis is alive'
    else
      critical 'Redis did not respond to the ping command'
    end
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

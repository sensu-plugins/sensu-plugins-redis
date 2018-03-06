#!/usr/bin/env ruby
#
#   check-redis-connection.rb
#
# DESCRIPTION:
#   This plugin checks the number of connections available on redis
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   check-redis-connections-available.rb -c COUNT -w COUNT -h HOST
#
# LICENSE:
#   Copyright Adrien Waksberg <adrien.waksberg@doctolib.fr>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisConnectionsAvailable < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  option :critical,
         short: '-c COUNT',
         long: '--critical COUNT',
         description: 'COUNT critical threshold for number of connections available',
         proc: proc(&:to_i),
         required: true

  option :warning,
         short: '-w COUNT',
         long: '--warning COUNT',
         description: 'COUNT warning threshold for number of connections available',
         proc: proc(&:to_i),
         required: true

  def run
    redis = Redis.new(default_redis_options)
    maxclients = redis.config('get', 'maxclients').last.to_i
    clients = redis.info.fetch('connected_clients').to_i
    conn_available = maxclients - clients

    if conn_available <= config[:critical]
      critical "Only #{conn_available} connections left available (#{clients}/#{maxclients})"
    elsif conn_available <= config[:warning]
      warning "Only #{conn_available} connections left available (#{clients}/#{maxclients})"
    else
      ok "There are #{conn_available} connections available (#{clients}/#{maxclients})"
    end
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

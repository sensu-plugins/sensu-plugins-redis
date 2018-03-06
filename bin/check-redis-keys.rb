#!/usr/bin/env ruby
#
# Checks number of keys matching a keys command are above the provided
# warn/critical levels
# ===
#
# Depends on redis gem
# gem install redis
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/check/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisKeysCheck < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  option :warn,
         short: '-w COUNT',
         long: '--warning COUNT',
         description: 'COUNT warning threshold for number of matching keys',
         proc: proc(&:to_i),
         required: true

  option :crit,
         short: '-c COUNT',
         long: '--critical COUNT',
         description: 'COUNT critical threshold for number of matching keys',
         proc: proc(&:to_i),
         required: true

  option :pattern,
         long: '--pattern PATTERN',
         description: 'Argument passed into keys command. Defaults to *',
         required: false,
         default: '*'

  def run
    redis = Redis.new(default_redis_options)

    length = redis.keys(config[:pattern]).size

    if length < config[:crit]
      critical "'keys #{config[:pattern]}' returned #{length} keys, which is below the critical limit of #{config[:crit]}"
    elsif length < config[:warn]
      warning "'keys #{config[:pattern]}' returned #{length} keys, which is below the warning limit of #{config[:warn]}"
    else
      ok "Redis list #{config[:pattern]} length is above thresholds"
    end
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

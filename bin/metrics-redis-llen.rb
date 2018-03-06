#!/usr/bin/env ruby
#
# Get the length of a list and push it to graphite
#
#
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/metric/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisListLengthMetric < Sensu::Plugin::Metric::CLI::Graphite
  include RedisClientOptions

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-S SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.redis"

  option :key,
         short: '-k KEY1,KEY2',
         long: '--key KEY',
         description: 'Comma separated list of keys to check',
         required: true

  def run
    redis = Redis.new(default_redis_options)

    redis_keys = config[:key].split(',')
    redis_keys.each do |key|
      output "#{config[:scheme]}.#{key}.items", redis.llen(key)
    end
    ok
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

#!/usr/bin/env ruby
# frozen_string_literal: false

#
# Get the number of keys and push it to graphite
#
#
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/metric/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisKeysNumberMetric < Sensu::Plugin::Metric::CLI::Graphite
  include RedisClientOptions

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-S SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.redis"

  option :metricname,
         short: '-M METRICNAME',
         long: '--metric-name METRICNAME',
         description: 'Name of the metric key. Defaults to "keys"',
         required: false,
         default: 'keys'

  option :pattern,
         long: '--pattern PATTERN',
         description: 'Argument passed into keys command. Defaults to *',
         required: false,
         default: '*'

  def run
    redis = Redis.new(default_redis_options)

    output "#{config[:scheme]}.#{config[:metricname]}", redis.keys(config[:pattern]).size

    ok
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

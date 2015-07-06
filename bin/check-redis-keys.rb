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

class RedisKeysCheck < Sensu::Plugin::Check::CLI
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

  option :database,
         short: '-n DATABASE',
         long: '--dbnumber DATABASE',
         description: 'Redis database number to connect to',
         proc: proc(&:to_i),
         required: false,
         default: 0

  option :password,
         short: '-P PASSWORD',
         long: '--password PASSWORD',
         description: 'Redis Password to connect with'

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
    options = { host: config[:host], port: config[:port], db: config[:database] }
    options[:password] = config[:password] if config[:password]
    redis = Redis.new(options)

    length = redis.keys(config[:pattern]).size

    if length < config[:crit]
      critical "'keys #{config[:pattern]}' returned #{length} keys, which is below the warning limit of #{config[:crit]}"
    elsif length < config[:warn]
      warning "'keys #{config[:pattern]}' returned #{length} keys, which is below the critical limit of #{config[:warn]}"
    else
      ok "Redis list #{config[:pattern]} length is above thresholds"
    end
  rescue
    unknown "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
  end
end

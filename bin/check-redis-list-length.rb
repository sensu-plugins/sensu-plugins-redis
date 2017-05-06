#!/usr/bin/env ruby
#
# Checks number of items in a Redis list key
# ===
#
# Depends on redis gem
# gem install redis
#
# Copyright (c) 2013, Piavlo <lolitushka@gmail.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/check/cli'
require 'redis'

class RedisListLengthCheck < Sensu::Plugin::Check::CLI
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
         description: 'COUNT warning threshold for number of items in Redis list key',
         proc: proc(&:to_i),
         required: true

  option :crit,
         short: '-c COUNT',
         long: '--critical COUNT',
         description: 'COUNT critical threshold for number of items in Redis list key',
         proc: proc(&:to_i),
         required: true

  option :key,
         short: '-k KEY',
         long: '--key KEY',
         description: 'Redis list KEY to check',
         required: true

  banner "Usage: #{File.basename($PROGRAM_NAME)} (options)\n" \
    'Number of items in list key will have to be below threshold if warning is smaller than critical, and above otherwise'

  def run
    options = { host: config[:host], port: config[:port], db: config[:database] }
    options[:password] = config[:password] if config[:password]

    check_length_is_above_threshold = false
    if config[:warn] > config[:crit]
      check_length_is_above_threshold = true
    end

    redis = Redis.new(options)
    length = redis.llen(config[:key])

    if check_length_is_above_threshold && length <= config[:crit]
      critical "Redis list #{config[:key]} is below or equal to the CRITICAL limit: #{length} length / #{config[:crit]} limit"
    elsif check_length_is_above_threshold && length <= config[:warn]
      warning "Redis list #{config[:key]} length is below or equal to the WARNING limit: #{length} length / #{config[:warn]} limit"
    elsif check_length_is_above_threshold
      ok "Redis list #{config[:key]} length is above thresholds"
    end

    if length >= config[:crit]
      critical "Redis list #{config[:key]} is above the CRITICAL limit: #{length} length / #{config[:crit]} limit"
    elsif length <= config[:warn]
      warning "Redis list #{config[:key]} length is above the WARNING limit: #{length} length / #{config[:warn]} limit"
    else
      ok "Redis list #{config[:key]} length is below thresholds"
    end
  rescue Redis::CommandError => error
    if error.message =~ /WRONGTYPE/
      unknown "Key provided (#{config[:key]}) is not a list"
    else
      unknown "A Redis command error occured #{error.message}"
    end
  rescue Redis::CannotConnectError
    unknown "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
  rescue
    unknown 'An unkown error occured'
  end
end

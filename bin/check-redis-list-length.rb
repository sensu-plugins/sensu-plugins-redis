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

  def run
    options = if config[:socket]
                { path: socket }
              else
                { host: config[:host], port: config[:port] }
              end

    options[:db] = config[:database]
    options[:password] = config[:password] if config[:password]
    redis = Redis.new(options)

    length =  case redis.type(config[:key])
              when 'hash'
                redis.hlen(config[:key])
              when 'set'
                redis.scard(config[:key])
              else
                redis.llen(config[:key])
              end

    if length >= config[:crit]
      critical "Redis list #{config[:key]} length is above the CRITICAL limit: #{length} length / #{config[:crit]} limit"
    elsif length >= config[:warn]
      warning "Redis list #{config[:key]} length is above the WARNING limit: #{length} length / #{config[:warn]} limit"
    else
      ok "Redis list #{config[:key]} length (#{length}) is below thresholds"
    end
  rescue
    unknown "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
  end
end

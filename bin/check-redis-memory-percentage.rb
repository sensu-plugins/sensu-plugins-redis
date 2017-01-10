#! /usr/bin/env ruby
#
#   check-redis-memory-percentage
#
# DESCRIPTION:
#   check redis memory usage in percentage
#
# OUTPUT:
#   Criticality of memory usage by redis
#
# PLATFORMS:
#   Linux but not tested (Windows, BSD, Solaris, etc)
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   system: awk, pattern scanning and processing language
#
# USAGE:
#   set warning and critical threshold for checks, option are verbose enough
#
# NOTES:
#   this script compares redis memory usage with system's total memory pulled from /proc/meminfo
#
# LICENSE:
#   Milan Thapa <milans.thapa78@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'redis'
class RedisChecks < Sensu::Plugin::Check::CLI
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

  option :warn_mem,
         short: '-w percentage',
         long: '--warnmem percentage',
         description: "Allocated % of Redis memory usage on which we'll issue a WARNING",
         proc: proc(&:to_i),
         required: true

  option :crit_mem,
         short: '-c percentage',
         long: '--critmem percentage',
         description: "Allocated % of Redis memory usage on which we'll issue a CRITICAL",
         proc: proc(&:to_i),
         required: true

  option :crit_conn,
         long: '--crit-conn-failure',
         boolean: true,
         description: 'Critical instead of warning on connection failure',
         default: false

  def system_memory
    `awk '/MemTotal/{print$2}' /proc/meminfo`.to_f * 1024
  end

  def run
    options = { host: config[:host], port: config[:port] }
    options[:password] = config[:password] if config[:password]
    redis = Redis.new(options)

    redis_info = redis.info
    memory_in_use = redis_info.fetch('used_memory').to_f.div(1024).to_f             # used memory in KB (KiloBytes)
    total_memory = redis_info.fetch('maxmemory', system_memory).to_f.div(1024).to_f # max memory (if specified) in KB

    used_memory = ((memory_in_use / total_memory) * 100).round(2)
    warn_memory = config[:warn_mem]
    crit_memory = config[:crit_mem]
    if used_memory >= crit_memory
      critical "Redis running on #{config[:host]}:#{config[:port]} is above the CRITICAL limit: #{used_memory}% used / #{crit_memory}%"
    elsif used_memory >= warn_memory
      warning "Redis running on #{config[:host]}:#{config[:port]} is above the WARNING limit: #{used_memory}% used / #{warn_memory}%"
    else
      ok "Redis memory usage: #{used_memory}% is below defined limits"
    end
  rescue
    message = "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
    if config[:crit_conn]
      critical message
    else
      warning message
    end
  end
end

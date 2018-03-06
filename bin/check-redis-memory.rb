#!/usr/bin/env ruby
#
# Checks Redis INFO stats and limits values
# ===
#
# Copyright (c) 2012, Panagiotis Papadomitsos <pj@ezgr.net>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/check/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class RedisChecks < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  option :warn_mem,
         short: '-w KB',
         long: '--warnmem KB',
         description: "Allocated KB of Redis memory on which we'll issue a WARNING",
         proc: proc(&:to_i),
         required: true

  option :crit_mem,
         short: '-c KB',
         long: '--critmem KB',
         description: "Allocated KB of Redis memory on which we'll issue a CRITICAL",
         proc: proc(&:to_i),
         required: true

  def run
    redis = Redis.new(default_redis_options)

    used_memory = redis.info.fetch('used_memory').to_i.div(1024)
    warn_memory = config[:warn_mem]
    crit_memory = config[:crit_mem]
    if used_memory >= crit_memory
      critical "Redis running on #{config[:host]}:#{config[:port]} is above the CRITICAL limit: #{used_memory}KB used / #{crit_memory}KB limit"
    elsif used_memory >= warn_memory
      warning "Redis running on #{config[:host]}:#{config[:port]} is above the WARNING limit: #{used_memory}KB used / #{warn_memory}KB limit"
    else
      ok "Redis memory usage: #{used_memory}KB is below defined limits"
    end
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

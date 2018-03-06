#!/usr/bin/env ruby
#
# Push Redis INFO stats into graphite
# ===
#
# Copyright 2012 Pete Shima <me@peteshima.com>
#                Brian Racer <bracer@gmail.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-plugin/metric/cli'
require 'redis'
require_relative '../lib/redis_client_options'

class Redis2Graphite < Sensu::Plugin::Metric::CLI::Graphite
  include RedisClientOptions

  # redis.c - sds genRedisInfoString(char *section)
  SKIP_KEYS_REGEX = [
    '^role',
    '^slave',
    'aof_last_bgrewrite_status',
    'aof_last_write_status',
    'arch_bits',
    'config_file',
    'executable',
    'gcc_version',
    'master_host',
    'master_link_status',
    'master_port',
    'mem_allocator',
    'multiplexing_api',
    'maxmemory_human',
    'maxmemory_policy',
    'os',
    'process_id',
    'rdb_last_bgsave_status',
    'redis_build_id',
    'redis_git_dirty',
    'redis_git_sha1',
    'redis_mode',
    'redis_version',
    'run_id',
    'tcp_port',
    'total_system_memory_human',
    'used_memory_human',
    'used_memory_lua_human',
    'used_memory_peak_human',
    'used_memory_rss_human'
  ].freeze

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-S SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.redis"

  option :skip_keys_regex,
         description: 'a comma seperated list of keys to be skipped',
         short: '-k KEYS',
         long: '--skipkeys KEYS',
         default: nil

  def run
    redis = Redis.new(default_redis_options)
    skip_keys = if !config[:skip_keys_regex].nil?
                  config[:skip_keys_regex].split(',')
                else
                  SKIP_KEYS_REGEX
                end

    redis.info.each do |k, v|
      next unless skip_keys.map { |re| k.match(/#{re}/) }.compact.empty?

      # "db0"=>"keys=123,expires=12"
      if k =~ /^db/
        keys, expires = v.split(',')
        keys.gsub!('keys=', '')
        expires.gsub!('expires=', '')

        output "#{config[:scheme]}.#{k}.keys", keys
        output "#{config[:scheme]}.#{k}.expires", expires
      else
        output "#{config[:scheme]}.#{k}", v
      end
    end

    # Loop thru commandstats entries for perf metrics
    redis.info('commandstats').each do |k, v|
      %w[calls usec_per_call usec].each do |x|
        output "#{config[:scheme]}.commandstats.#{k}.#{x}", v[x]
      end
    end

    ok
  rescue StandardError
    send(config[:conn_failure_status], "Could not connect to Redis server on #{redis_endpoint}")
  end
end

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

class Redis2Graphite < Sensu::Plugin::Metric::CLI::Graphite
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

  option :host,
         short: '-h HOST',
         long: '--host HOST',
         description: 'Redis Host to connect to',
         default: '127.0.0.1'

  option :port,
         short: '-p PORT',
         long: '--port PORT',
         description: 'Redis Port to connect to',
         proc: proc(&:to_i),
         default: 6379

  option :password,
         short: '-P PASSWORD',
         long: '--password PASSWORD',
         description: 'Redis Password to connect with'

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.redis"

  option :timeout,
         description: 'Timeout to connect to redis host',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: Redis::Client::DEFAULTS[:timeout]

  option :reconnect_attempts,
         description: 'Reconnect attempts to redis host',
         short: '-r ATTEMPTS',
         long: '--reconnect ATTEMPTS',
         proc: proc(&:to_i),
         default: Redis::Client::DEFAULTS[:reconnect_attempts]

  option :skip_keys_regex,
         description: 'a comma seperated list of keys to be skipped',
         short: '-k',
         long: '--skipkeys',
         default: nil

  def run
    options = {
      host: config[:host],
      port: config[:port],
      timeout: config[:timeout],
      reconnect_attempts: config[:reconnect_attempts]
    }
    options[:password] = config[:password] if config[:password]
    redis = Redis.new(options)
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
      %w(['calls', 'usec_per_call', 'usec']).each do |x|
        output "#{config[:scheme]}.commandstats.#{k}.#{x}", v[x]
      end
    end

    ok
  end
end

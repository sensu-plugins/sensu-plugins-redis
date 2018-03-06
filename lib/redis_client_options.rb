require 'redis'
require 'sensu-plugin/metric/cli'

module RedisClientOptions
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      _configure_options
    end
  end

  def default_redis_options
    opts = {}
    opts[:password] = config[:password] if config[:password]
    opts[:timeout]  = config[:timeout]  if config[:timeout]
    opts[:db]       = config[:database] if config[:database]

    if config[:socket]
      opts[:path] = config[:socket]
    else
      opts[:host] = config[:host]
      opts[:port] = config[:port]
    end
    opts
  end

  def redis_endpoint
    if config[:socket]
      "unix://#{config[:socket]}"
    else
      "#{config[:host]}:#{config[:port]}"
    end
  end

  module ClassMethods
    def _configure_options
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
             default: Redis::Client::DEFAULTS[:host]

      option :port,
             short: '-p PORT',
             long: '--port PORT',
             description: 'Redis Port to connect to',
             proc: proc(&:to_i),
             required: false,
             default: Redis::Client::DEFAULTS[:port]

      option :database,
             short: '-n DATABASE',
             long: '--dbnumber DATABASE',
             description: 'Redis database number to connect to',
             proc: proc(&:to_i),
             required: false,
             default: Redis::Client::DEFAULTS[:db]

      option :password,
             short: '-P PASSWORD',
             long: '--password PASSWORD',
             description: 'Redis Password to connect with'

      option :conn_failure_status,
             long: '--conn-failure-status EXIT_STATUS',
             description: 'Returns the following exit status for Redis connection failures',
             default: 'critical',
             in: %w[unknown warning critical]

      option :timeout,
             short: '-t TIMEOUT',
             long: '--timeout TIMEOUT',
             description: 'Redis connection timeout',
             proc: proc(&:to_f),
             required: false,
             default: Redis::Client::DEFAULTS[:timeout]

      option :reconnect_attempts,
             description: 'Reconnect attempts to Redis host',
             short: '-r ATTEMPTS',
             long: '--reconnect ATTEMPTS',
             proc: proc(&:to_i),
             default: Redis::Client::DEFAULTS[:reconnect_attempts]
    end
  end
end

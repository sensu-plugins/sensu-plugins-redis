require_relative '../spec_helper.rb'
require_relative '../../lib/redis_client_options.rb'
require 'redis'

class DummyRedisCheck < Sensu::Plugin::Check::CLI
  include RedisClientOptions

  def run
    Redis.new(default_redis_options).ping
  end
end

describe 'DummyRedisCheck', '#run' do
  it 'accepts config' do
    args = %w[--host 127.0.0.1 --password foobar]
    check = DummyRedisCheck.new(args)
    expect(check.config[:password]).to eq 'foobar'
  end

  it 'sets socket option accordingly' do
    args = %w[--socket /some/path/redis.sock]
    check = DummyRedisCheck.new(args)
    expect(check.config[:socket]).to eq '/some/path/redis.sock'
  end

  it 'prefers socket option over host:port' do
    args = %w[--host 10.0.0.1 -port 3456 --socket /some/path/redis.sock]
    check = DummyRedisCheck.new(args)
    expect(check.default_redis_options[:path]).to eq '/some/path/redis.sock'
    expect(check.default_redis_options[:host]).to be_nil
    expect(check.default_redis_options[:port]).to be_nil
  end

  it 'output conn info for host:port' do
    args = %w[--host 10.0.0.1 --port 3456]
    check = DummyRedisCheck.new(args)
    expect(check.redis_endpoint).to eq '10.0.0.1:3456'
  end

  it 'output conn info for host:port' do
    args = %w[--socket /some/path/redis.sock --host 10.0.0.1 --port 3456]
    check = DummyRedisCheck.new(args)
    expect(check.redis_endpoint).to eq 'unix:///some/path/redis.sock'
  end
end

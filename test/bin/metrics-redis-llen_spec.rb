require_relative '../spec_helper.rb'
require_relative '../../bin/metrics-redis-llen.rb'

describe 'RedisListLengthMetric', '#run' do
  before(:all) do
    RedisListLengthMetric.class_variable_set(:@@autorun, nil)
  end

  it 'accepts config' do
    args = %w[--host 10.0.0.1 --port 3456 --password foobar -k key1]
    check = RedisListLengthMetric.new(args)
    expect(check.default_redis_options[:password]).to eq 'foobar'
    expect(check.default_redis_options[:host]).to eq '10.0.0.1'
    expect(check.default_redis_options[:port]).to eq 3456
  end

  it 'sets socket option accordingly' do
    args = %w[--socket /some/path/redis.sock -k key1]
    check = RedisListLengthMetric.new(args)
    expect(check.default_redis_options[:path]).to eq '/some/path/redis.sock'
    expect(check.default_redis_options[:host]).to be_nil
    expect(check.default_redis_options[:port]).to be_nil
  end

  it 'returns warning' do
    args = %w[--host 1.1.1.1 --port 1234 --conn-failure-status warning --timeout 0.1 -k key1]
    check = RedisListLengthMetric.new(args)
    expect(check).to receive(:warning).with('Could not connect to Redis server on 1.1.1.1:1234').and_raise(SystemExit)
    expect { check.run }.to raise_error(SystemExit)
  end
end

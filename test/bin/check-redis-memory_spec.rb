# frozen_string_literal: false

require_relative '../spec_helper.rb'
require_relative '../../bin/check-redis-memory.rb'

describe 'RedisChecks', '#run' do
  before(:all) do
    RedisChecks.class_variable_set(:@@autorun, nil)
  end

  it 'accepts config' do
    args = %w[
      --host 127.0.0.1
      --password foobar
      --warnmem 524288
      --critmem 1048576
    ]
    check = RedisChecks.new(args)
    expect(check.config[:password]).to eq 'foobar'
  end

  it 'sets socket option accordingly' do
    args = %w[
      --socket /some/path/redis.sock
      --warnmem 524288
      --critmem 1048576
    ]
    check = RedisChecks.new(args)
    expect(check.config[:socket]).to eq '/some/path/redis.sock'
  end

  it 'returns warning' do
    args = %w[
      --host 1.1.1.1
      --port 1234
      --conn-failure-status warning
      --timeout 0.1
      --warnmem 524288
      --critmem 1048576
    ]
    check = RedisChecks.new(args)
    expect(check).to receive(:warning).with('Could not connect to Redis server on 1.1.1.1:1234').and_raise(SystemExit)
    expect { check.run }.to raise_error(SystemExit)
  end
end

require_relative './spec_helper.rb'
require_relative '../bin/check-redis-ping.rb'

describe 'CheckRedisPing', '#run' do
  before(:all) do
    RedisPing.class_variable_set(:@@autorun, nil)
  end

  it 'accepts config' do
    args = %w(--host 127.0.0.1 --password foobar)
    check = RedisPing.new(args)
    expect(check.config[:password]).to eq 'foobar'
  end

  it 'returns warning' do
    args = %w(--host 1.1.1.1 --port 1234 --conn-failure-status warning)
    check = RedisPing.new(args)
    expect(check).to receive(:warning).with('Could not connect to Redis server on 1.1.1.1:1234').and_raise(SystemExit)
    expect { check.run }.to raise_error(SystemExit)
  end
end

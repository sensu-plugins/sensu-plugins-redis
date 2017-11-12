# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-redis-ping.rb'
check = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe file(check) do
  it { should be_file }
  it { should be_executable }
end

describe command("#{check} --conn-failure-status warning") do
  its(:exit_status) { should eq 1 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Could not connect to Redis server on 127.0.0.1:6379'))) }
end

describe command("#{check} -P foobared") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis is alive'))) }
end

describe command("#{check} -s /tmp/redis.sock -P foobared") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis is alive'))) }
end

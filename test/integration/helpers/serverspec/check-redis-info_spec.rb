# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-redis-info.rb'
check = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

# Expected key value should return OK
describe command("#{check} -P foobared -K tcp_port -V 6379") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis tcp_port is 6379'))) }
end

# Unexpected key value should return Critical
describe command("#{check} -P foobared -K tcp_port -V 5000") do
  its(:exit_status) { should eq 2 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis tcp_port is 6379!'))) }
end

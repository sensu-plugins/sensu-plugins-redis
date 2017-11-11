# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-redis-memory-percentage.rb'
check = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command("#{check} -P foobared -w 100 -c 101") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('below defined limits'))) }
end

describe command("#{check} -P foobared -w 0 -c 5000") do
  its(:exit_status) { should eq 1 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis running on 127.0.0.1:6379 is above the WARNING limit'))) }
end

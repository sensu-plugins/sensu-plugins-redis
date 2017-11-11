# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'metrics-redis-graphite.rb'
check = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command("#{check} -P foobared --skipkeys cluster_enabled") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('redis.maxmemory 0'))) }
  its(:stdout) { should_not match(Regexp.new(Regexp.escape('redis.cluster_enabled'))) }
end

# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-redis-connections-available.rb'
check = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command("#{check} -P foobared -w 1 -c 2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match('OK') }
end

describe command("#{check} -P foobared -w 9999 -c 2") do
  its(:exit_status) { should eq 1 }
  its(:stdout) { should match('WARNING') }
end

describe command("#{check} -P foobared -w 1 -c 9999") do
  its(:exit_status) { should eq 2 }
  its(:stdout) { should match('CRITICAL') }
end

# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-redis-list-length.rb'
check = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command("#{check} -P foobared -k alpha_key_list --critical 10 --warning 2") do
  its(:exit_status) { should eq 1 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis list alpha_key_list length is above the WARNING limit: 5 length / 2 limit'))) }
end

# Non existant key shoul return zero
describe command("#{check} -P foobared -k non_existant_key --critical 10 --warning 2") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(Regexp.new(Regexp.escape('Redis list non_existant_key length (0) is below thresholds'))) }
end

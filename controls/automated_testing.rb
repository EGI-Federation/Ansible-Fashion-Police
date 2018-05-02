
# encoding: utf-8

# Copyright 2018 EGI Foundation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

title 'Must have CI'
if ENV['TEST_ROLE_PATH'].nil?
  raise 'Please set the path to the role you want to test with TEST_ROLE_PATH'
end
test_role_path = ENV['TEST_ROLE_PATH'].to_s

control 'Travis' do
  impact 0.5
  title 'Roles should have continuous integration with Travis'
  desc 'Roles should have a properly configured .travis.yml file to ensure that they are tested'

  travis_file = test_role_path + '/.travis.yml'
  describe file(travis_file) do
    it { should be } # must have a travis
  end

  describe yaml(travis_file) do
    its(['notifications', 'webhooks']) { should cmp 'https://galaxy.ansible.com/api/v1/notifications/' } # must have galaxy notifications
    its(['script']) { should include 'molecule test' }
  end
end

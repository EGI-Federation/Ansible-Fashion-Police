
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

title 'Galaxy'
if ENV['TEST_ROLE_PATH'].nil?
  raise 'Please set the path to the role you want to test with TEST_ROLE_PATH'
end
test_role_path = ENV['TEST_ROLE_PATH'].to_s
# Meta must contain the information
control 'Meta' do
  impact 0.6
  title 'Meta must contain Galaxy-relevant information'
  desc 'The meta/main.yml file must support all platforms of EGI sites'
  metafile = yaml(test_role_path + '/meta/main.yml')
  describe(metafile) do
    its ['galaxy_info'] { should be }
  end

  metafile['galaxy_info', 'platforms'].each do |platform|
    describe(platform) do
      its ['name'] { should be_in ['EL', 'Debian'] }
    end
  end
end

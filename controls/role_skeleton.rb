
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

title 'Ansible skeleton'
if ENV['TEST_ROLE_PATH'].nil?
  raise 'Please set the path to the role you want to test with TEST_ROLE_PATH'
end
test_role_path = ENV['TEST_ROLE_PATH'].to_s
ansible_dirs = ['defaults', 'handlers', 'meta', 'tasks', 'vars']

control 'Ansible Skeleton Directories' do # A unique ID for this control
  impact 0.8 # The criticality, if this control fails.
  title 'Ensure all Ansible role directories are present' # A human-readable title
  desc 'Ansible Galaxy needs the defaults, files, handlers, meta, tasks and vars directories to be present'
  ansible_dirs.each do |ansible_dir|
    ansible_dir = test_role_path + ansible_dir
    describe file(ansible_dir) do # The actual test
      it { should be_directory }
    end
  end
end

control 'Ansible main YAML files' do
  impact 1.0
  title 'Each directory must have at least a main.yml'
  desc 'Ansible needs a main.yml file in each directory. Use include_files if you need'
  ansible_dirs.each do |ansible_dir|
    mainfile = test_role_path + ansible_dir + '/main.yml'
    describe file(mainfile) do
      it { should be_file }
    end
  end
end

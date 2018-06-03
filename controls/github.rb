require 'httparty'
require 'json'
require 'awesome_print'

title 'GitHub repo should be properly configured'

if ENV['GITHUB_TOKEN'].nil?
  raise 'Please set the GITHUB_TOKEN environment variable'
end
if ENV['GITHUB_REPO'].nil?
  raise 'Please set the GITHUB_REPO environment variable'
end

github_token = ENV['GITHUB_TOKEN']
repo = ENV['GITHUB_REPO']
github_api = 'https://api.github.com'

control 'Name follows Naming Convention' do
  impact 0.1
  title 'Repo name should follow naming convention'
  desc 'The naming convention for ansible repos should follow the style guide'
  json_file = 'naming_convention.json'
  options = {
    headers: {
      'Accept' => 'application/json',
      'token' => github_token,
      'User-Agent' => 'httparty'
    }
  }
  url = github_api + "/repos/EGI-Foundation/" + repo
  File.open(json_file,'w') do |f|
    f.write(HTTParty.get(url, options))
  end
  describe json(json_file) do
    its ('name') { should match /^ansible.*-role$/ }
  end
  File.delete(json_file)
end

control 'Master branch is protected' do
  impact 0.2
  title 'The master branch should be protected'
  desc 'The master branch of the repo should be protected.'
  options = {
    headers: {
      'Accept' => 'application/vnd.github.luke-cage-preview+json',
      'token' => github_token,
      'User-Agent' => 'httparty'
    }
  }
  url = github_api + "/repos/EGI-Foundation/" + repo + "/branches/master/protection"
  puts url
  response = HTTParty.get(url, options)
  json_file = 'master_branch.json'
  File.open(json_file,'w') do |f|
    f.write(response)
  end
  only_if do
    response.parsed_response['message'] != 'Not Found'
  end
  describe json(json_file) do
    its(['required_status_checks']['strict']) { should be }
  end
end

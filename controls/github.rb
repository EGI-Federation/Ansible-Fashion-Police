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

control 'Repo Name' do
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
  url = github_api + '/repos/EGI-Foundation/' + repo
  File.open(json_file, 'w') do |f|
    f.write(HTTParty.get(url, options))
  end
  describe json(json_file) do
    its('name') { should match(/^ansible.*-role$/) }
  end
  File.delete(json_file)
end

control 'Master branch' do
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
  url = github_api + '/repos/EGI-Foundation/' + repo + '/branches/master/protection'
  response = HTTParty.get(url, options)
  json_file = 'master_branch.json'
  File.open(json_file, 'w') do |f|
    f.write(response)
  end
  ap response.parsed_response
  
  only_if do
    !(response.parsed_response['message'].match '/Not Found/')
  end

  # describe json(json_file) do
  #   its(['required_status_checks']['strict']) { should be 'True' }
  # end
end

  # File.delete(json_file)

control 'Issue Labels' do
  title 'Check GitHub Issue Labels'
  desc 'Expected GitHub issue labels should be there.'
  impact 0.5
  options = {
    headers: {
      'Accept' => 'application/vnd.github.symmetra-preview+json',
      'token' => github_token,
      'User-Agent' => 'httparty'
    }
  }
  url = github_api + '/repos/EGI-Foundation/' + repo + '/labels'
  reference_url = github_api + '/repos/EGI-Foundation/ansible-style-guide/labels'
  # puts url
  response = HTTParty.get(url, options)
  ref_response = HTTParty.get(reference_url, options)
  json_file = 'labels.json'
  ref_file = 'ref_labels.json'
  File.open(json_file, 'w') do |f|
    f.write(response)
  end
  File.open(ref_file, 'w') do |f|
    f.write(ref_response)
  end
  # Compare list to reference list
  # response.parsed_response.each do |label|
  #   ap label['name']
  # end
  # loop over them and asser that they are present
end

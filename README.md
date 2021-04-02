[![Build Status](https://travis-ci.org/EGI-Federation/Ansible-Fashion-Police.svg?branch=master)](https://travis-ci.org/EGI-Federation/Ansible-Fashion-Police) 
[![DOI](https://zenodo.org/badge/131844947.svg)](https://zenodo.org/badge/latestdoi/131844947)

# EGI Ansible Fashion Police

This is an [InSpec](https://inspec.io) profile, which tests compliance with the EGI Ansible Style.

This profile is meant to guide developers of [Ansible](http://www.ansible.com) roles for use in the EGI
federation write them consistently  with a [consensus-based
style guide](https://github.com/EGI-Federation/ansible-style-guide).

## Controls

We implement controls for:

- [Automated testing](controls/automated_testing.rb)
- [GitHub repository configuraiton](controls/github.rb)
- [Role Metadata](controls/role_meta.rb)
- [Role Skeleton](controls/role_skeleton.rb)

according to the Ansible style guide in use.

# How to use this profile

**TL;DR: set a few variables, run the profile**:

  1. You will need to interact with the GitHub API - get a token and set it in the environment : `export GITHUB_TOKEN=super_secret_token`
  2. Set the name of the repo you want to assert compliance of : `export GITHUB_REPO=cmd` (this should be a repo under the @EGI-Federation org)
  3. `inspec supermarket exec brucellino/ansible-style-guide`
  4. If you want it hot off the press, use the git fetcher : `inspec exec -b local http://github.com/EGI-Federation/ansible-fashion-police`

*This profile should be included in your continuous integration pipeline.*

## Prerequisites

You will need [Inspec](https://inspec.io) to use this profile.
This implies a ruby ( ~> 2.4) runtime environment and the necessary gems.

1. Install [ruby gems](https://rubygems.org/pages/download)
2. Install bundler : `gem install bundler`
3. Install dependencies: `bundle`

## Using the profile locally

This profile expects the role to be in GitHub repository, configured according to good practice.
If you use the [Ansible Galaxy skeleton provided by the style guide](https://github.com/EGI-Federation/ansible-style-guide/tree/master/egi-galaxy-template) you should be fine :clap:
If you are developing a new Ansible role locally and want to use this profile, you're going to have control failures  for aspects of the repo configuration (master branch protection, labels, _etc_).
**You can disable these controls temporarily** - see [the Inspec docs](https://www.inspec.io/docs/reference/cli/).

# Contributing

We're not taking contributions right now.
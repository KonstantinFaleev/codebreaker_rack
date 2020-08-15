# frozen_string_literal: true

source "https://rubygems.org"
ruby '2.7.1'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'rack'
gem 'codebreaker', github: 'KonstantinFaleev/codebreaker', branch: 'development'

group :development, :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'rspec_file_chef'
  gem 'simplecov', '~> 0.13.0'
end
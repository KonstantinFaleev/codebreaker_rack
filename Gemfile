# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.7.1'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'codebreaker', github: 'KonstantinFaleev/codebreaker', branch: 'development'
gem 'rack'

group :development, :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec_file_chef'
  gem 'rubocop'
  gem 'simplecov', '~> 0.13.0'
end

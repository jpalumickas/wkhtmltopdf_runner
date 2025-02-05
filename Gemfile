# frozen_string_literal: true

source 'https://rubygems.org'

group :development do
  gem 'pry', '~> 0.15'
  gem 'rubocop', '~> 1.71', require: false
  gem 'rubocop-rspec', '~> 3.4', require: false
end

group :development, :test do
  gem 'simplecov'

  gem 'rake', '~> 13.2'
  gem 'rspec', '~> 3.13'
  gem 'wkhtmltopdf-binary', '~> 0.12.6'
end

# Specify your gem's dependencies in wkhtmltopdf_runner.gemspec
gemspec

# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in robinhood.gemspec
gemspec

group :test do
  gem 'rake', '~> 10.1'
  gem 'rspec', '~> 3.0'
  gem 'fakeweb', '~> 1.3'
  gem 'rack', '~> 1.3'
end

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "spicerack-styleguide", require: false
end

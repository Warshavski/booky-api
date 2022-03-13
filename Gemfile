# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.4'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# A Ruby implementation of GraphQL.
# https://github.com/rmosolgo/graphql-ruby
gem 'graphql'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Application server
# https://github.com/puma/puma
gem 'puma', '~> 5.0'

# A Ruby interface to the PostgreSQL RDBMS.
# https://github.com/ged/ruby-pg
gem 'pg'

# A fast JSON parser and Object marshaller as a Ruby gem.
# https://github.com/ohler55/oj
gem 'oj'

# File Attachment toolkit for Ruby applications.
# https://github.com/shrinerb/shrine
gem 'shrine', '>= 3.3'

# Rack middleware for blocking & throttling
# https://github.com/kickstarter/rack-attack
gem 'rack-attack'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.
# https://github.com/cyu/rack-cors
gem 'rack-cors', '>= 1.0.6', require: 'rack/cors'

# Abort requests that are taking too long
# https://github.com/sharpstone/rack-timeout
gem 'rack-timeout'

# Exception tracking and logging from Ruby to Rollbar https://docs.rollbar.com/docs/ruby
# https://github.com/rollbar/rollbar-gem
gem 'rollbar'

group :development, :test do
  # Help to kill N+1 queries and unused eager loading
  # https://github.com/flyerhzm/bullet
  gem 'bullet'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Shim to load environment variables from .env into ENV in development.
  # https://github.com/bkeepers/dotenv
  gem 'dotenv-rails'
end

# Static code analyzer and formatter. Keep your code clean.
gem 'rubocop', require: false
gem 'rubocop-rspec', require: false

# TODO : add when it will support Ruby 3
# gem 'debase'
# gem 'ruby-debug-ide'

group :development do
  # Static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  # https://github.com/presidentbeef/brakeman
  gem 'brakeman'
  gem 'listen', '~> 3.3'
  gem 'graphiql-rails'
  gem 'pry-rails'

  # Provide a quality report of your Ruby code.
  # https://github.com/whitesmith/rubycritic
  gem 'rubycritic', require: false
end

group :test do
  gem 'database_cleaner'

  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-parameterized', require: false
  gem 'rspec-rails'
  gem 'rspec-sqlimit'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers', '>= 4.0.0'
  gem 'simplecov'

  # Ruby Tests Profiling Toolbox
  # https://github.com/palkan/test-prof
  gem 'test-prof'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

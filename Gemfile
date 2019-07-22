source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# https://github.com/exAspArk/batch-loader
# Powerful tool to avoid N+1 DB or HTTP queries
gem 'batch-loader'

# https://github.com/carrierwaveuploader/carrierwave
# Provides a simple and extremely flexible way to upload files from Ruby applications
gem 'carrierwave'

# https://github.com/minimagick/minimagick
# Mini replacement for RMagick
gem 'mini_magick', '>= 4.9.4'

# https://github.com/plataformatec/devise
# Flexible authentication solution for Rails with Warden.
gem 'devise', '>= 4.6.1'

# OAuth 2 provider for Ruby on Rails / Grape.
# https://github.com/doorkeeper-gem/doorkeeper
gem 'doorkeeper', '>= 5.0.1'

# https://github.com/Netflix/fast_jsonapi
# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'

# https://github.com/ohler55/oj
# A fast JSON parser and Object marshaller as a Ruby gem.
gem 'oj'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'

# https://github.com/binarylogic/settingslogic
# Settingslogic is a simple configuration / settings solution that uses an ERB enabled YAML file.
gem 'settingslogic'

# A Ruby/Rack web server built for concurrency
# https://github.com/puma/puma
gem 'puma', '~> 3.7'

# A Ruby interface to the PostgreSQL RDBMS.
# https://github.com/ged/ruby-pg
gem 'pg'

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
# https://github.com/kaminari/kaminari
gem 'kaminari'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Rack middleware for blocking & throttling
# https://github.com/kickstarter/rack-attack
gem 'rack-attack'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.
# https://github.com/cyu/rack-cors
gem 'rack-cors', require: 'rack/cors'

# Cache
gem 'connection_pool'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'rspec-parameterized', require: false
end

group :development do
  # Help to kill N+1 queries and unused eager loading
  # https://github.com/flyerhzm/bullet
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'pry-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-sqlimit'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Booky
  class Application < Rails::Application
    require_relative Rails.root.join('lib/booky/redis/wrapper')
    require_relative Rails.root.join('lib/booky/redis/cache')

    Rails.application.routes.default_url_options = {
      host: Rails.application.secrets.domain_name,
      tld_length: 1
    }

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.eager_load_paths.push(*%W[#{config.root}/lib])

    # TODO : Fix uninitialized constant problem
    #
    # This middleware needs to precede ActiveRecord::QueryCache and
    # other middlewares that connect to the database.
    #
    # config.middleware.insert_after(Rails::Rack::Logger, ::Middleware::HealthCheck)

    #
    # Allow access to Booky API from other domains
    #
    config.middleware.insert_before(0, Rack::Cors) do
      #
      # Cross-origin requests must not have the session cookie available
      #
      allow do
        origins '*'
        resource '/api/*',
                 credentials: false,
                 headers: :any,
                 methods: :any,
                 expose: %w[Link X-Total X-Total-Pages X-Per-Page X-Page X-Next-Page X-Prev-Page]
      end
    end

    #
    # Use caching across all environments
    #
    caching_config_hash = ::Booky::Redis::Cache.params
    caching_config_hash[:namespace] = ::Booky::Redis::Cache::CACHE_NAMESPACE

    #
    # Limit cache grow
    #
    caching_config_hash[:expires_in] = 2.weeks

    config.cache_store = :redis_store, caching_config_hash
  end
end

# frozen_string_literal: true

unless Rails.env.test?
  Rack::Timeout::Logger.level = Logger::ERROR

  BookyApi::Application.configure do |config|
    timeout_configuration = {
      service_timeout: ENV.fetch('RAILS_RACK_TIMEOUT', 60).to_i,
      wait_timeout: ENV.fetch('RAILS_WAIT_TIMEOUT', 90).to_i
    }

    config.middleware.insert_before(Rack::Runtime, Rack::Timeout, **timeout_configuration)
  end
end

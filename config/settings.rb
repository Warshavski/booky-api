# frozen_string_literal: true

require 'settingslogic'

# Settings
#
#   Used to get access to the application settings
#
class Settings < Settingslogic
  source ENV.fetch('BOOKY_CONFIG') { Pathname.new(File.expand_path('..', __dir__)).join('config/booky.yml') }
  namespace ENV.fetch('BOOKY_ENV') { Rails.env }

  class << self
    def absolute(path)
      File.expand_path(path, Rails.root)
    end

    def host_without_www(url)
      host(url).sub('www.', '')
    end

    def host(url)
      url = url.downcase
      url = "http://#{url}" unless url.start_with?('http')

      #
      # Get rid of the path so that we don't even have to encode it
      #
      url_without_path = url.sub(%r{(https?://[^/]+)/?.*}, '\1')

      URI.parse(url_without_path).host
    end

    def build_base_booky_url
      base_url(booky).join('')
    end

    private

    def base_url(config)
      custom_port = on_standard_port?(config) ? nil : ":#{config.port}"

      [
        config.protocol,
        '://',
        config.host,
        custom_port
      ]
    end

    def on_standard_port?(config)
      config.port.to_i == (config.https ? 443 : 80)
    end
  end
end

# frozen_string_literal: true

paths_to_be_protected = [Constants::GRAPHQL_ENDPOINT]

#
# Create one big regular expression that matches strings starting with any of the paths_to_be_protected.
#
paths_regex = Regexp.union(paths_to_be_protected.map { |path| /\A#{Regexp.escape(path)}/ })

rack_attack_enabled = Booky.config.rack_attack.enabled
ip_whitelist = Booky.config.rack_attack.ip_whitelist

unless Rails.env.test? || !rack_attack_enabled
  Rack::Attack.throttle('protected paths', limit: 10, period: 60.seconds) do |req|
    if req.post? && req.path =~ paths_regex
      req.ip
    end
  end

  Rack::Attack.safelist('allow') do |req|
    ip_whitelist.include?(req.ip)
  end
end

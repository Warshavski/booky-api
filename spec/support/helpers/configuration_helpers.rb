require 'active_support/core_ext/hash/transform_values'
require 'active_support/hash_with_indifferent_access'
require 'active_support/dependencies'

require_dependency 'booky'

module ConfigurationHelpers
  def stub_config_setting(messages)
    allow(Booky.config.booky).to receive_messages(to_settings(messages))
  end

  private

  # Modifies stubbed messages to also stub possible predicate versions
  #
  # Examples:
  #
  #   add_predicates(foo: true)
  #   # => {foo: true, foo?: true}
  #
  #   add_predicates(signup_enabled?: false)
  #   # => {signup_enabled? false}
  #
  def add_predicates(messages)
    # Only modify keys that aren't already predicates
    keys = messages.keys.map(&:to_s).reject { |k| k.end_with?('?') }

    keys.each do |key|
      predicate = key + '?'
      messages[predicate.to_sym] = messages[key.to_sym]
    end
  end

  # Support nested hashes by converting all values into Settingslogic objects
  def to_settings(hash)
    hash.transform_values do |value|
      if value.is_a? Hash
        Settingslogic.new(value.deep_stringify_keys)
      else
        value
      end
    end
  end
end

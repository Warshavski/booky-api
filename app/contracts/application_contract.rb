# frozen_string_literal: true

# ApplicationContract
#
#   Common logic and configuration across all contracts
#
class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :en
  config.messages.backend = :i18n
end

# frozen_string_literal: true

# ApplicationContract
#
#   Common logic and configuration across all contracts
#
class ApplicationContract < Dry::Validation::Contract
  DIGITS_REGEXP = /^\d+$/

  private_constant :DIGITS_REGEXP

  config.messages.default_locale = :en
  config.messages.backend = :i18n

  private

  def future?(value)
    value.present? && value > Date.current
  end
end

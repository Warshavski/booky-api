# frozen_string_literal: true

# ContractValidator
#
#   Used to perform call contract and compose errors
#
class ContractValidator
  HTTP_STATUS_CODE = 400

  private_constant :HTTP_STATUS_CODE

  def self.call(klass:, context:)
    new(klass, context).validate
  end

  def initialize(klass, context)
    @contract_klass = klass
    @interactor_context = context
  end

  def validate
    contract_params = @interactor_context.params.to_h
    contract_result = @contract_klass.new.call(contract_params)

    return unless contract_result.failure?

    errors = present_errors(contract_result)
    @interactor_context.fail!(errors: errors)
  end

  private

  def present_errors(contract_result)
    errors = contract_result.errors.to_h

    errors.each_with_object([]) do |(attribute, messages), result|
      messages.each do |error_message|
        result << compose_error(attribute, error_message)
      end
    end
  end

  def compose_error(attribute, message)
    {
      code: HTTP_STATUS_CODE,
      path: [:parameter, attribute],
      message: message
    }
  end
end

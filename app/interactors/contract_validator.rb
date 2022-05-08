# frozen_string_literal: true

# ContractValidator
#
#   Used to perform call contract and compose errors
#
class ContractValidator
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

    errors =
      Errors::ContractErrorsSerializer.new(contract_result).serialize

    @interactor_context.fail!(errors: errors)
  end
end

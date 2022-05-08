# frozen_string_literal: true

module Errors
  # Errors::ContractErrorsSerializer
  #
  #   Used to serializer contract validation errors
  #
  class ContractErrorsSerializer
    HTTP_STATUS_CODE = 400

    private_constant :HTTP_STATUS_CODE

    def initialize(contract_result)
      @contract_result = contract_result
    end

    def serialize
      errors = @contract_result.errors.to_h

      errors.each_with_object([]) do |(attribute, messages), result|
        messages.each do |error_message|
          result << compose_error(attribute, error_message)
        end
      end
    end

    private

    def compose_error(attribute, message)
      {
        code: HTTP_STATUS_CODE,
        path: [:parameter, attribute],
        message: message
      }
    end
  end
end

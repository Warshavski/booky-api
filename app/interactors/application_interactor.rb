# frozen_string_literal: true

# ApplicationInteractor
#
#   Interactors base class that contains common logic for all interactors across application
#
class ApplicationInteractor
  include ::Interactor

  class << self
    def contract(contract_klass)
      before { ContractValidator.call(klass: contract_klass, context: context) }
    end
  end
end

# frozen_string_literal: true

module Publishers
  # Publishers::Create
  #
  class Create < ApplicationInteractor
    contract MutationContract

    def call
      context.object = Publisher.create!(context.params)
    end
  end
end

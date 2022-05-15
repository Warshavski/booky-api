# frozen_string_literal: true

module Authors
  # Authors::Create
  #
  class Create < ApplicationInteractor
    contract MutationContract

    def call
      context.object = Author.create!(context.params)
    end
  end
end

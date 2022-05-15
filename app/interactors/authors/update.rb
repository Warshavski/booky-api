# frozen_string_literal: true

module Authors
  # Authors::Update
  #
  class Update < ApplicationInteractor
    contract MutationContract

    def call
      context.object = author.tap { |a| a.update!(context.params) }
    end

    private

    def author
      @author ||= Author.find(context.id)
    end
  end
end

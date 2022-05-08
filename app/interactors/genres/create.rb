# frozen_string_literal: true

module Genres
  # Genres::Create
  #
  class Create < ApplicationInteractor
    contract Genres::CreateContract

    def call
      context.object = Genre.create!(context.params)
    end
  end
end

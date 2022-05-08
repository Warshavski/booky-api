# frozen_string_literal: true

module Genres
  # Genres::CreateContract
  #
  class CreateContract < ApplicationContract
    params do
      required(:name).filled(:str?)
      optional(:description).filled(:str?)
    end

    rule(:name) do
      key.failure(:taken) if value.present? && Genre.exists?(name: value)
    end
  end
end

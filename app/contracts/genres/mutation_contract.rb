# frozen_string_literal: true

module Genres
  # Genres::MutationContract
  #
  class MutationContract < ApplicationContract
    params do
      required(:name).filled(:string)
      optional(:description).filled(:string)
    end

    rule(:name) do
      key.failure(:taken) if value.present? && Genre.exists?(name: value)
    end
  end
end

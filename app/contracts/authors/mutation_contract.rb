# frozen_string_literal: true

module Authors
  # Authors::MutationContract
  #
  class MutationContract < ApplicationContract
    params do
      required(:first_name).filled(:string)
      required(:last_name).filled(:string)
      optional(:biography).filled(:string)
      optional(:born_in).filled(:date)
      optional(:died_in).filled(:date)
    end

    rule(:born_in, :died_in) do
      key(:born_in).failure(:invalid) if future?(values[:born_in])
      key(:died_in).failure(:invalid) if future?(values[:died_in])

      if key? && values[:born_in] > values[:died_in]
        key(:born_in).failure(:invalid)
        key(:died_in).failure(:invalid)
      end
    end
  end
end

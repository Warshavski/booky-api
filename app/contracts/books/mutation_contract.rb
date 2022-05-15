# frozen_string_literal: true
module Books
  # Books::MutationContract
  #
  class MutationContract < ApplicationContract
    params do
      required(:title).filled(:str?)
      optional(:description).filled(:str?)

      required(:published_in).filled(:date)

      optional(:weight).filled(:int?, gteq?: 0)
      required(:pages_count).filled(:int?, gteq?: 0)

      optional(:isbn13).filled(:str?, format?: DIGITS_REGEXP, size?: 13)
      optional(:isbn10).filled(:str?, format?: DIGITS_REGEXP, size?: 10)
    end

    rule(:isbn10, :isbn13) do
      key.failure(:taken) if book_exist?(values[:isbn10], values[:isbn13])
    end

    rule(:published_in) do
      key.failure(:invalid) if future?(value)
    end

    private

    def book_exist?(isbn10, isbn13)
      Book.by_isbn(isbn10: isbn10, isbn13: isbn13).exists?
    end
  end
end

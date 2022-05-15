# frozen_string_literal: true

module Publishers
  # Publishers::MutationContract
  #
  class MutationContract < ApplicationContract
    params do
      required(:name).filled(:str?)
      optional(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
      optional(:phone).filled(:str?, format?: DIGITS_REGEXP)
      optional(:address).filled(:str?)
      optional(:postcode).filled(:str?, format?: DIGITS_REGEXP)
      optional(:description).filled(:str?)
    end

    rule(:name) do
      key.failure(:taken) if value.present? && Publisher.iwhere(name: value).exists?
    end
  end
end

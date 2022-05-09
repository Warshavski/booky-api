# frozen_string_literal: true

FactoryBot.define do
  factory :publisher, class: Publisher do
    name { Faker::Book.publisher }

    trait :with_books do
      after(:build) { |publisher, _| publisher.books = [build(:book)] }
    end
  end
end

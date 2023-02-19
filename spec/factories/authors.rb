# frozen_string_literal: true

FactoryBot.define do
  factory :author, class: Author do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }

    biography { Faker::Lorem.paragraph }

    born_in { Faker::Date.backward(days: 10_000) }
    died_in { Faker::Date.backward(days: 300) }

    trait :with_books do
      after(:build) { |author, _| author.books = [build(:book)] }
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :author, class: Author do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }

    trait :with_books do
      after(:build) { |author, _| author.books = [build(:book)] }
    end
  end
end

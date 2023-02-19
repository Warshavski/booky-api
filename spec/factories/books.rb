# frozen_string_literal: true

FactoryBot.define do
  factory :book, class: Book do
    association :publisher, factory: :publisher

    title { "#{Faker::Book.title}-#{Faker::Number.number(digits: 3)}" }
    description { Faker::Lorem.paragraph }

    pages_count { Faker::Number.positive.to_i }
    published_in { Faker::Date.backward }

    isbn10 { Faker::Barcode.ean(8) << '12'}
    isbn13 { Faker::Barcode.isbn }

    trait :with_authors do
      after(:build) { |book, _| book.authors = [build(:author)] }
    end

    trait :with_genres do
      after(:build) { |book, _| book.genres = [build(:genre)] }
    end
  end
end

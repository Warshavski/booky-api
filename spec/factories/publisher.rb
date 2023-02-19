# frozen_string_literal: true

FactoryBot.define do
  factory :publisher, class: Publisher do
    name { "#{Faker::Book.publisher}-#{Faker::Number.number(digits: 3)}" }

    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }

    address   { Faker::Address.full_address }
    postcode  { Faker::Address.postcode }

    description { Faker::Lorem.paragraph }

    trait :with_books do
      after(:build) { |publisher, _| publisher.books = [build(:book)] }
    end
  end
end

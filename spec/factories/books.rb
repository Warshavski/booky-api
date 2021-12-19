# frozen_string_literal: true

FactoryBot.define do
  factory :book, class: Book do
    publisher

    title { Faker::Book.title }
    pages_count { Faker::Number.positive.to_i }
    published_at { Faker::Date.backward }
  end
end

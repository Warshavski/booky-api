# frozen_string_literal: true

FactoryBot.define do
  factory :genre, class: Genre do
    name { "#{Faker::Book.genre}-#{Faker::Number.number(digits: 3)}" }
    description { Faker::Lorem.paragraph }
  end
end

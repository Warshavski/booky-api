# frozen_string_literal: true

FactoryBot.define do
  factory :genre, class: Genre do
    name { Faker::Book.genre }
  end

  factory :genre_seq, class: Genre do
    sequence(:name, (1..10).cycle) { |n| "v#{n}" }
  end
end

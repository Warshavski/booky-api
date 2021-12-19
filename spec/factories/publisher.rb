# frozen_string_literal: true

FactoryBot.define do
  factory :publisher, class: Publisher do
    name { Faker::Book.publisher }
  end
end

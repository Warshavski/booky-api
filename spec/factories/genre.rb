# frozen_string_literal: true

FactoryBot.define do
  factory :genre, class: Genre do
    name { "#{Faker::Book.genre}-#{rand(100)}" }
  end
end

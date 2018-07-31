FactoryBot.define do
  factory :publisher, class: Publisher do
    name { Faker::Book.publisher }
  end
end

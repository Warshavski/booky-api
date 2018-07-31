FactoryBot.define do
  factory :shop, class: Shop do
    name { Faker::Company.name }
  end
end

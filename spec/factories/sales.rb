FactoryBot.define do
  factory :sale, class: Sale do
    association :shop, factory: :shop
    association :book, factory: :book

    quantity 1
  end
end

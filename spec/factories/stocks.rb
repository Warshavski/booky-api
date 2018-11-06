FactoryBot.define do
  factory :stock, class: Stock do
    association :book, factory: :book
    association :shop, factory: :shop

    quantity { 1 }
  end
end

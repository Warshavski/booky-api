FactoryBot.define do
  factory :book, class: Book do
    title { Faker::Book.title }

    association :publisher, factory: :publisher
  end
end

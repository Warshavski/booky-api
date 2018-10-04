FactoryBot.define do
  factory :book, class: Book do
    title { Faker::Book.title }
    published_at { Faker::Date.between('2018-01-01', '2018-12-31') }

    association :publisher, factory: :publisher
  end
end

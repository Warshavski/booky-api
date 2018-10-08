FactoryBot.define do
  factory :book, class: Book do
    title { Faker::Book.title }
    published_at { Faker::Date.between('2018-01-01', '2018-12-31') }

    association :publisher, factory: :publisher
  end

  factory :book_seq, class: Book, parent: :book do
    sequence(:title, (1..10).cycle) { |n| "v#{n}" }
  end
end

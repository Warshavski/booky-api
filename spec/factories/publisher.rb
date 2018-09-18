FactoryBot.define do
  factory :publisher, class: Publisher do
    name { Faker::Book.publisher }
  end

  factory :publisher_with_books, class: Publisher, parent: :publisher do
    transient do
      books_count 2
    end

    after(:create) do |publisher, evaluator|
      create_list(:book, evaluator.books_count, publisher: publisher)
    end
  end

  factory :publisher_seq, class: Publisher, parent: :publisher do
    sequence(:name, (1..10).cycle) { |n| "v#{n}" }
  end
end

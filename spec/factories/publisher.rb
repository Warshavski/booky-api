FactoryBot.define do
  factory :publisher, class: Publisher do
    name { Faker::Book.publisher }
  end

  factory :publisher_with_books, class: Publisher, parent: :publisher do
    transient do
      books_count { 2 }
    end

    after(:create) do |publisher, evaluator|
      create_list(:book, evaluator.books_count, publisher: publisher)
    end
  end

  factory :publisher_seq, class: Publisher, parent: :publisher do
    sequence(:name, (1..10).cycle) { |n| "v#{n}" }
  end

  factory :publisher_params, class: Hash do
    initialize_with do
      {
        id: 1,
        type: 'publisher',
        attributes: {
          name: Faker::Book.publisher,
          description: Faker::Lorem.sentences,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.phone_number
        }
      }
    end
  end
end

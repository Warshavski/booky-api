require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should { have_many(:books) } }

    it { should { have_many(:books_in_shops).class_name('Book').source(:books) } }

    it { should { have_many(:shops_with_books).through(:books_in_stock).source(:shops) } }
  end
end

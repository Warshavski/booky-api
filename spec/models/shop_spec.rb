require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should { have_many(:stocks) } }

    it { should { have_many(:available_books).through(:stock) } }

    it { should { have_many(:not_empty_stocks).source(:stock).class_name('Stock') } }

    it { should { have_many(:books_in_stock).through(:not_empty_stocks).source(:book) } }

    it { should { have_many(:sales) } }

    it { should { have_many(:sold_books).through(:sales).source(:book) } }
  end
end

require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:book) }

    it { should validate_presence_of(:shop) }

    it { should validate_presence_of(:quantity) }

    it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(1) }

    it { should have_db_column(:quantity) }
  end

  describe 'associations' do
    it { should belong_to(:book) }

    it { should belong_to(:shop) }
  end
end

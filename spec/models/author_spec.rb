require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }

    it { should validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:books_authors).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:books_authors) }
  end
end

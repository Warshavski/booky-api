require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:books_authors).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:books_authors) }
  end
end

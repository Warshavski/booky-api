require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:books).dependent(:restrict_with_exception ) }
  end
end

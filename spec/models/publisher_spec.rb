require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:books).dependent(:restrict_with_exception ) }
  end
end

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }

    it { should validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { should { have_and_belong_to_many(:books) } }
  end

  # describe '.search' do
  #   let(:author) { create(:author, first_name: 'first', last_name: 'last') }
  #
  #   it 'returns author with a matching first_name' do
  #     expect(described_class.search(author.first_name)).to eq([author])
  #   end
  #
  #   it 'returns author with a partially matching first_name' do
  #     expect(described_class.search(author.first_name[0..2])).to eq([author])
  #   end
  #
  #   it 'returns author with a matching first_name regardless of the casing' do
  #     expect(described_class.search(author.first_name.upcase)).to eq([author])
  #   end
  #
  #   it 'returns author with a matching last_name' do
  #     expect(described_class.search(author.last_name)).to eq([author])
  #   end
  #
  #   it 'returns author with a partially matching last_name' do
  #     expect(described_class.search(author.last_name[0..2])).to eq([author])
  #   end
  #
  #   it 'returns author with a matching last_name regardless of the casing' do
  #     expect(described_class.search(author.last_name.upcase)).to eq([author])
  #   end
  # end
end

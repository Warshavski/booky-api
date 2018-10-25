require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'validations' do
    subject { create(:genre) }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { should { have_and_belong_to_many(:books) } }
  end

  describe 'before_save' do
    let(:genre) { create(:genre, name: 'GENRE') }

    context '#create' do
      it { expect(genre.name).to eq('genre') }
    end

    context '#update' do
      it 'updates name in downcase' do
        genre.update!(name: 'WAT')

        expect(genre.reload.name).to eq('wat')
      end
    end
  end

  describe '.search' do
    let(:genre) { create(:genre, name: 'wat-genre?') }

    it 'returns genre with a matching name' do
      expect(described_class.search(genre.name)).to eq([genre])
    end

    it 'returns genre with a partially matching name' do
      expect(described_class.search(genre.name[0..2])).to eq([genre])
    end

    it 'returns genre with a matching name regardless of the casing' do
      expect(described_class.search(genre.name.upcase)).to eq([genre])
    end
  end
end

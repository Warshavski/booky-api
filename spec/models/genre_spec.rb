# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:books_genres).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:books_genres) }
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
end

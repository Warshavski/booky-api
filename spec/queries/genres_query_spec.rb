require 'rails_helper'

RSpec.describe GenresQuery do
  describe '.call' do
    subject { described_class.call(params: params) }

    let_it_be(:expected_search_genre)  { create(:genre, name: 'title-00') }
    let_it_be(:genres) { create_list(:genre, 3).prepend(expected_search_genre) }

    let(:params) { {} }

    it { is_expected.to eq(genres.reverse) }

    context 'when search param is equal to title' do
      let(:params) { { search: expected_search_genre.name } }

      it { is_expected.to eq([expected_search_genre]) }
    end

    context 'when search param is equal to partially matching title' do
      let(:params) { { search: expected_search_genre.name[0..2] } }

      it { is_expected.to eq([expected_search_genre]) }
    end

    context 'when search param is equal to title regardless of the casing' do
      let(:params) { { search: expected_search_genre.name.upcase } }

      it { is_expected.to eq([expected_search_genre]) }
    end
  end
end

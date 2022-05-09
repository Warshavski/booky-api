require 'rails_helper'

RSpec.describe AuthorsQuery do
  describe '.call' do
    subject { described_class.call(params: params) }

    let_it_be(:expected_search_author) do
      create(:author, first_name: 'first_name-00', last_name: 'lastName')
    end

    let_it_be(:authors) do
      create_list(:author, 3, :with_books).prepend(expected_search_author)
    end

    let(:params) { {} }

    it { is_expected.to eq(authors.reverse) }

    context 'when search param is equal to first_name' do
      let(:params) { { search: expected_search_author.first_name } }

      it { is_expected.to eq([expected_search_author]) }
    end

    context 'when search param is equal to partially matching first_name' do
      let(:params) { { search: expected_search_author.first_name[0..2] } }

      it { is_expected.to eq([expected_search_author]) }
    end

    context 'when search param is equal to first_name regardless of the casing' do
      let(:params) { { search: expected_search_author.first_name.upcase } }

      it { is_expected.to eq([expected_search_author]) }
    end

    context 'when search param is equal to last_name' do
      let(:params) { { search: expected_search_author.last_name } }

      it { is_expected.to eq([expected_search_author]) }
    end

    context 'when search param is equal to partially matching last_name' do
      let(:params) { { search: expected_search_author.last_name[0..2] } }

      it { is_expected.to eq([expected_search_author]) }
    end

    context 'when search param is equal to last_name regardless of the casing' do
      let(:params) { { search: expected_search_author.last_name.upcase } }

      it { is_expected.to eq([expected_search_author]) }
    end
  end
end

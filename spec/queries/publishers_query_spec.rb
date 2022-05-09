require 'rails_helper'

RSpec.describe PublishersQuery do
  describe '.call' do
    subject { described_class.call(params: params) }

    let_it_be(:expected_search_publisher) do
      create(:publisher, name: 'name-00')
    end

    let_it_be(:publishers) do
      create_list(:publisher, 1).prepend(expected_search_publisher)
    end

    let(:params) { {} }

    it { is_expected.to eq(publishers.reverse) }

    context 'when search param is equal to name' do
      let(:params) { { search: expected_search_publisher.name } }

      it { is_expected.to eq([expected_search_publisher]) }
    end

    context 'when search param is equal to partially matching name' do
      let(:params) { { search: expected_search_publisher.name[0..2] } }

      it { is_expected.to eq([expected_search_publisher]) }
    end

    context 'when search param is equal to name regardless of the casing' do
      let(:params) { { search: expected_search_publisher.name.upcase } }

      it { is_expected.to eq([expected_search_publisher]) }
    end
  end
end

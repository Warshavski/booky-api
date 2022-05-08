# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filterable do
  before do
    class FakeQuery
      include Filterable

      specify_filter(:wat) do |items, filter_value|
        items.where(title: filter_value)
      end

      specify_filter(:so) do |items, filter_value|
        items.where(description: filter_value)
      end

      attr_reader :filter_params

      def execute(scope, params)
        @filter_params = params

        filter(scope)
      end
    end
  end

  after { Object.send :remove_const, :FakeQuery }

  subject { FakeQuery.new.execute(Book.all, params) }

  let_it_be(:books) do
    collection = [2, 1, 3].map do |number|
      create(:book, title: "title", description:"#{number}description")
    end

    collection.push(create(:book, title: '1name', description: '1description'))
  end

  context 'when filter params does not set' do
    let(:params) { {} }

    it { is_expected.to eq(books) }
  end

  context 'when single filter parameter is set' do
    let(:params) { { wat: 'title' } }

    it { is_expected.to eq(books[0..2]) }
  end

  context 'when multiple filter params are set' do
    let(:params) { { wat: '1name', so: '1description'} }

    it { is_expected.to eq([books[3]]) }
  end

  context 'when filter value is blank' do
    let(:params) { { wat: '' } }

    it 'is expected to skip filter' do
      is_expected.to eq(books)
    end
  end

  context 'when filter value does not set' do
    let(:params) { { wat: nil, so: '2description' } }

    it 'is expected to skip filter' do
      is_expected.to eq([books[0]])
    end
  end
end

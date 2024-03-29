# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sortable do
  before do
    class FakeFinder
      include Sortable

      sorting :wat do |scope, direction|
        scope.order(title: direction, id: direction)
      end

      sorting :so, attributes: :description, direction: :asc

      sorting :hey, attributes: :description

      attr_reader :params

      def execute(scope, params)
        @params = params

        sort(scope)
      end
    end
  end

  after { Object.send :remove_const, :FakeFinder }

  subject { FakeFinder.new.execute(Book.all, params) }

  let_it_be(:books) do
    [2, 1, 3].map do |number|
      create(:book, title: "#{number}title", description:"#{number}description")
    end
  end

  context 'when sort params are not provider' do
    let(:params) { {} }

    it 'is expected to sort by id in descending direction' do
      is_expected.to eq(books)
    end
  end

  context 'when sort parameter is set in ascending mode' do
    let(:params) { { sort: 'title' } }

    it 'is expected to sort by provided parameter in ascending direction' do
      is_expected.to eq([books.second, books.first, books.third])
    end
  end

  context 'when sort parameter set in descending mode' do
    let(:params) { { sort: '-title' } }

    it 'is expected to sort by provided parameter in descending direction' do
      is_expected.to eq([books.third, books.first, books.second])
    end
  end

  context 'when sort parameter set within multiple attributes' do
    let_it_be(:extra_book) { create(:book, title: '1title' ) }

    let(:params) { { sort: '-title,id' } }

    it 'is expected to sort by provided parameters' do
      is_expected.to eq([books.third, books.first, books.second, extra_book])
    end
  end

  context 'when custom sort parameter is set' do
    let_it_be(:extra_book) do
      create(:book, title: '1title', description: '0description' )
    end

    let(:params) { { sort: '-wat' } }

    it 'is expected to sort by provided parameters' do
      is_expected.to eq([books.third, books.first, extra_book, books.second])
    end

    context 'when sort specified via hash without direction' do
      let(:params) { { sort: 'hey' } }

      it 'is expected to sort by provided parameters' do
        is_expected.to eq([extra_book, books.second, books.first, books.third])
      end

      context 'when direction is set' do
        let(:params) { { sort: '-hey' } }

        it 'is expected to sort by provided parameters' do
          is_expected.to eq([books.third, books.first, books.second, extra_book])
        end
      end
    end

    context 'when sort specified via hash with direction' do
      let(:params) { { sort: 'so' } }

      it 'is expected to sort by provided parameters' do
        is_expected.to eq([extra_book, books.second, books.first, books.third])
      end

      context 'when direction is set' do
        let(:params) { { sort: '-so' } }

        it 'is expected to sort by provided parameters' do
          is_expected.to eq([extra_book, books.second, books.first, books.third])
        end
      end
    end
  end
end

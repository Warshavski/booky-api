require 'rails_helper'

RSpec.describe GenresFinder do

  describe '#execute' do
    let!(:genres) { create_list(:genre_seq, 10) }

    context 'sort only' do
      it 'sorts by recently_created' do
        genres_finder = described_class.new(sort: 'created_asc')
        result = genres_finder.execute

        expect(result.first.name).to eq('v1')
      end

      it 'sorts by last_created' do
        genres_finder = described_class.new(sort: 'created_desc')
        result = genres_finder.execute

        expect(result.first.name).to eq('v10')
      end

      it 'sorts by name ascending' do
        genres_finder = described_class.new(sort: 'name_asc')
        result = genres_finder.execute

        expect(result.first.name).to eq('v1')
      end

      it 'sorts by name descending' do
        genres_finder = described_class.new(sort: 'name_desc')
        result = genres_finder.execute

        expect(result.first.name).to eq('v9')
      end
    end

    context 'filter only' do
      it 'filters genres by name' do
        genres_finder = described_class.new(search: 'v7')
        result = genres_finder.execute

        expect(result.first.name).to eq('v7')
        expect(result.count).to be(1)
      end

      it 'does not find any genre with given search parameter' do
        genres_finder = described_class.new(search: 'wat-name?')
        result = genres_finder.execute

        expect(result.count).to be(0)
      end
    end

    context 'filter and sort' do
      it 'filters genres by name and sorts by recently_created' do
        genres_finder = described_class.new(sort: 'created_desc', search: 'v')
        result = genres_finder.execute

        expect(result.last.name).to eq('v1')
        expect(result.count).to eq(10)
      end

      it 'filters genres by name and sorts by last_created' do
        genres_finder = described_class.new(sort: 'created_asc', search: 'v')
        result = genres_finder.execute

        expect(result.last.name).to eq('v10')
        expect(result.count).to eq(10)
      end

      it 'filters genres by name and sorts by name descending' do
        genres_finder = described_class.new(sort: 'name_desc', search: 'v')
        result = genres_finder.execute

        expect(result.first.name).to eq('v9')
        expect(result.count).to eq(10)
      end

      it 'filters genres by name and sorts by name ascending' do
        genres_finder = described_class.new(sort: 'name_asc', search: 'v')
        result = genres_finder.execute

        expect(result.first.name).to eq('v1')
        expect(result.count).to eq(10)
      end
    end
  end
end

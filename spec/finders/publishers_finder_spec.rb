require 'rails_helper'

RSpec.describe PublishersFinder do

  describe '#execute' do
    before(:all) { create_list(:publisher_seq, 10) }

    after(:all) { Publisher.delete_all }

    context 'sort only' do
      it 'sorts by recently_created' do
        publishers_finder = described_class.new(sort: 'created_asc')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v1')
      end

      it 'sorts by last_created' do
        publishers_finder = described_class.new(sort: 'created_desc')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v10')
      end

      it 'sorts by name ascending' do
        publishers_finder = described_class.new(sort: 'created_desc')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v10')
      end

      it 'sorts by name descending' do
        publishers_finder = described_class.new(sort: 'created_desc')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v10')
      end
    end

    context 'filter only' do
      it 'filters publishers by name' do
        publishers_finder = described_class.new(search: 'v7')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v7')
        expect(result.count).to eq(1)
      end

      it 'does not find any publishers with given name' do
        publishers_finder = described_class.new(search: 'wat name')
        result = publishers_finder.execute

        expect(result.count).to eq(0)
      end

      it 'filters publishers by limit' do
        publishers_finder = described_class.new(limit: 5)
        result = publishers_finder.execute

        expect(result.count).to be(5)
      end

      it 'filters publishers by page' do
        allow(Booky.config.pagination).to receive(:limit).and_return(5)

        publishers_finder = described_class.new(page: 2)
        result = publishers_finder.execute

        expect(result.count).to be(5)
        expect(result.first.name).to eq('v6')
      end

      it 'filters publishers by page and limit' do
        publishers_finder = described_class.new(page: 1, limit: 5)
        result = publishers_finder.execute

        expect(result.count).to be(5)
        expect(result.last.name).to eq('v5')
      end

      it 'does not finds any publisher by page of range' do
        publishers_finder = described_class.new(page: 100)
        result = publishers_finder.execute

        expect(result.count).to be(0)
      end

      it 'does not returns any publisher by zero limit' do
        publishers_finder = described_class.new(limit: 0)
        result = publishers_finder.execute

        expect(result.count).to be(0)
      end
    end

    context 'filter and sort' do
      before { create(:publisher, name: 'so wat?') }

      it 'filters publishers by name and sorts by recently_created' do
        publishers_finder = described_class.new(sort: 'created_desc', search: 'v')
        result = publishers_finder.execute

        expect(result.last.name).to eq('v1')
        expect(result.count).to eq(10)
      end

      it 'filters publishers by name and sorts by last_created' do
        publishers_finder = described_class.new(sort: 'created_asc', search: 'v')
        result = publishers_finder.execute

        expect(result.last.name).to eq('v10')
        expect(result.count).to eq(10)
      end

      it 'filters publishers by name and sorts by name descending' do
        publishers_finder = described_class.new(sort: 'name_desc', search: 'v')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v9')
        expect(result.count).to eq(10)
      end

      it 'filters publishers by name and sorts by name ascending' do
        publishers_finder = described_class.new(sort: 'name_asc', search: 'v')
        result = publishers_finder.execute

        expect(result.first.name).to eq('v1')
        expect(result.count).to eq(10)
      end

      it 'filters publishers by page and limit and sorts by name ascending' do
        publishers_finder = described_class.new(sort: 'name_asc', page: 2, limit: 5)
        result = publishers_finder.execute

        expect(result.first.name).to eq('v4')
        expect(result.count).to eq(5)
      end
    end
  end
end

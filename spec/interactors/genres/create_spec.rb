require 'rails_helper'

RSpec.describe Genres::Create do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      { name: genre_name, description: genre_description }
    end

    let(:genre_name)        { 'name' }
    let(:genre_description) { 'description' }

    it 'is expected to create a new genre' do
      expect { subject }.to change(Genre, :count).by(1)

      expect(subject.success?).to be(true)

      expected_genre = Genre.order(id: :desc).first
      expect(subject.object).to eq(expected_genre)
    end

    context 'when genre params are blank' do
      let(:genre_description) { '' }
      let(:genre_name) { nil }

      it 'is expected to fail with error' do
        is_expected.to be_failure

        expected_errors = [
          {
            code: 400,
            path: %i[parameter name],
            message: 'must be filled'
          },
          {
            code: 400,
            path: %i[parameter description],
            message: 'must be filled'
          }
        ]
        expect(subject.errors).to match(expected_errors)
      end
    end

    context 'when genre params does not set' do
      let(:params) { {} }

      it 'is expected to fail with error' do
        is_expected.to be_failure

        expected_errors = [
          {
            code: 400,
            path: %i[parameter name],
            message: 'is missing'
          }
        ]
        expect(subject.errors).to match(expected_errors)
      end
    end

    context 'when genre with the same name is already exist' do
      before { create(:genre, name: genre_name) }

      it 'is expected to fail with error' do
        is_expected.to be_failure

        expected_errors = [
          {
            code: 400,
            path: %i[parameter name],
            message: 'has already been taken'
          }
        ]
        expect(subject.errors).to match(expected_errors)
      end
    end
  end
end

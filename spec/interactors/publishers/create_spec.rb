require 'rails_helper'

RSpec.describe Publishers::Create do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        name: 'name',
        email: 'email@wat.com',
        phone: '0987654321',
        postcode: '0987654321',
        address: 'wat address 163',
        description: 'description',
      }
    end

    it 'is expected to create a new publisher' do
      expect { subject }.to change(Publisher, :count).by(1)

      expect(subject.success?).to be(true)

      expected_publisher = Publisher.order(id: :desc).first
      actual_publisher = subject.object
      expect(actual_publisher).to eq(expected_publisher)

      actual_attributes =
        actual_publisher.attributes.except('id', 'created_at', 'updated_at')

      expected_attributes = params.stringify_keys

      expect(actual_attributes).to eq(expected_attributes)
    end

    context 'when publisher params are invalid' do
      let(:params) do
        {
          email: 'email-wat.com',
          phone: 'phone',
          postcode: 'code123',
          address: '',
          description: nil,
        }
      end

      it 'is expected to fail with error' do
        is_expected.to be_failure

        expected_errors = [
          { code: 400, message: "is missing", path: [:parameter, :name] },
          { code: 400, message: "is in invalid format", path: [:parameter, :email] },
          { code: 400, message: "is in invalid format", path: [:parameter, :phone] },
          { code: 400, message: "must be filled", path: [:parameter, :address]},
          { code: 400, message: "is in invalid format", path: [:parameter, :postcode]},
          { code: 400, message: "must be filled", path: [:parameter, :description]}
        ]
        expect(subject.errors).to match(expected_errors)
      end
    end
  end
end

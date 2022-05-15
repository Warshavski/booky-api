# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::Inputs::PublisherAttributes do
  it 'is expected to has the correct arguments' do
    actual_argument_keys = described_class.arguments.keys
    expected_argument_keys = %w[name email phone postcode address description]

    expect(actual_argument_keys).to match_array(expected_argument_keys)
  end
end

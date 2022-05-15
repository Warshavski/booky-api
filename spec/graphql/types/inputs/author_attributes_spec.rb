# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::Inputs::AuthorAttributes do
  it 'is expected to has the correct arguments' do
    actual_argument_keys = described_class.arguments.keys
    expected_argument_keys = %w[firstName lastName biography bornIn diedIn bookIds]

    expect(actual_argument_keys).to match_array(expected_argument_keys)
  end
end

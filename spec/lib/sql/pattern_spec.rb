require 'rails_helper'
require 'sql/pattern'

describe SQL::Pattern do
  let(:dummy) { Class.new { include SQL::Pattern } }

  describe '.to_pattern' do
    context 'when a query is shorter than 3 chars' do
      it 'returns exact matching pattern' do
        expect(dummy.to_pattern('wa')).to eq('wa')
      end

      it 'returns sanitized exact matching pattern' do
        expect(dummy.to_pattern('w_')).to eq('w\_')
      end
    end

    context 'when a query is equal to 3 chars' do
      it 'returns partial matching pattern' do
        expect(dummy.to_pattern('wat')).to eq('%wat%')
      end

      it 'returns sanitized partial matching pattern' do
        expect(dummy.to_pattern('wa_')).to eq('%wa\_%')
      end
    end

    context 'when a query is longer than 3 chars' do
      it 'returns partial matching pattern' do
        expect(dummy.to_pattern('watso')).to eq('%watso%')
      end

      it 'returns sanitized partial matching pattern' do
        expect(dummy.to_pattern('wat_')).to eq('%wat\_%')
      end
    end
  end
end

require 'rails_helper'

describe Booky::Database do
  before do
    stub_const('MigrationTest', Class.new { include Booky::Database })
  end

  describe '.config' do
    it 'returns a Hash' do
      expect(described_class.config).to be_an_instance_of(Hash)
    end
  end

  describe '.adapter_name' do
    it 'returns the name of the adapter' do
      expect(described_class.adapter_name).to be_an_instance_of(String)
    end
  end

  describe '.postgresql?' do
    subject { described_class.postgresql? }

    it { is_expected.to satisfy { |val| val == true || val == false } }
  end

  describe '.nulls_last_order' do
    before do
      expect(described_class).to receive(:postgresql?).and_return(true)
    end

    it { expect(described_class.nulls_last_order('column', 'ASC')).to eq 'column ASC NULLS LAST'}
    it { expect(described_class.nulls_last_order('column', 'DESC')).to eq 'column DESC NULLS LAST'}
  end
end

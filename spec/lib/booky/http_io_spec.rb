require 'rails_helper'

describe Booky::HttpIO do
  include HttpIOHelpers

  let(:http_io) { described_class.new(url, size) }

  let(:url) { 'http://object-storage/trace' }
  let(:file_path) { expand_fixture_path('trace/sample_trace') }
  let(:size) { File.size(file_path) }

  describe '#close' do
    subject { http_io.close }

    it { is_expected.to be_nil }
  end

  describe '#binmode' do
    subject { http_io.binmode }

    it { is_expected.to be_nil }
  end

  describe '#binmode?' do
    subject { http_io.binmode? }

    it { is_expected.to be_truthy }
  end

  describe '#path' do
    subject { http_io.path }

    it { is_expected.to be_nil }
  end

  describe '#url' do
    subject { http_io.url }

    it { is_expected.to eq(url) }
  end

  describe '#seek' do
    subject { http_io.seek(pos, where) }

    context 'when moves pos to end of the file' do
      let(:pos) { 0 }
      let(:where) { IO::SEEK_END }

      it { is_expected.to eq(size) }
    end

    context 'when moves pos to middle of the file' do
      let(:pos) { size / 2 }
      let(:where) { IO::SEEK_SET }

      it { is_expected.to eq(size / 2) }
    end

    context 'when moves pos around' do
      it 'matches the result' do
        expect(http_io.seek(0)).to eq(0)
        expect(http_io.seek(100, IO::SEEK_CUR)).to eq(100)
        expect { http_io.seek(size + 1, IO::SEEK_CUR) }.to raise_error('new position is outside of file')
      end
    end
  end

  describe '#eof?' do
    subject { http_io.eof? }

    context 'when current pos is at end of the file' do
      before do
        http_io.seek(size, IO::SEEK_SET)
      end

      it { is_expected.to be_truthy }
    end

    context 'when current pos is not at end of the file' do
      before do
        http_io.seek(0, IO::SEEK_SET)
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '#write' do
    subject { http_io.write(nil) }

    it { expect { subject }.to raise_error(NotImplementedError) }
  end

  describe '#truncate' do
    subject { http_io.truncate(nil) }

    it { expect { subject }.to raise_error(NotImplementedError) }
  end

  describe '#flush' do
    subject { http_io.flush }

    it { expect { subject }.to raise_error(NotImplementedError) }
  end

  describe '#present?' do
    subject { http_io.present? }

    it { is_expected.to be_truthy }
  end
end

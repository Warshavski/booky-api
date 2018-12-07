# frozen_string_literal: true

require 'rails_helper'

describe Booky::FileTypeDetection do
  def upload_fixture(filename)
    fixture_file_upload(File.join('spec', 'fixtures', filename))
  end

  describe '#image_or_video?' do
    context 'when class is an uploader' do
      let(:dummy_uploader) do
        dummy_uploader = Class.new(CarrierWave::Uploader::Base) do
          include Booky::FileTypeDetection

          storage :file
        end

        dummy_uploader.new
      end

      it 'returns true for an image file' do
        dummy_uploader.store!(upload_fixture('dk.png'))

        expect(dummy_uploader).to be_image_or_video
      end

      it 'returns true for a video file' do
        dummy_uploader.store!(upload_fixture('video_sample.mp4'))

        expect(dummy_uploader).to be_image_or_video
      end

      it 'returns false for other extensions' do
        dummy_uploader.store!(upload_fixture('doc_sample.txt'))

        expect(dummy_uploader).not_to be_image_or_video
      end

      it 'returns false if filename is blank' do
        dummy_uploader.store!(upload_fixture('dk.png'))

        allow(dummy_uploader).to receive(:filename).and_return(nil)

        expect(dummy_uploader).not_to be_image_or_video
      end
    end

    context 'when class is a regular class' do
      let(:dummy_class) do
        dummy_class = Class.new do
          include Booky::FileTypeDetection

          def filename; end
        end

        dummy_class.new
      end

      it 'returns true for an image file' do
        allow(dummy_class).to receive(:filename).and_return('dk.png')

        expect(dummy_class).to be_image_or_video
      end

      it 'returns true for a video file' do
        allow(dummy_class).to receive(:filename).and_return('video_sample.mp4')

        expect(dummy_class).to be_image_or_video
      end

      it 'returns false for other extensions' do
        allow(dummy_class).to receive(:filename).and_return('doc_sample.txt')

        expect(dummy_class).not_to be_image_or_video
      end

      it 'returns false if filename is blank' do
        allow(dummy_class).to receive(:filename).and_return(nil)

        expect(dummy_class).not_to be_image_or_video
      end
    end
  end
end

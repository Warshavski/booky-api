require 'rails_helper'

class DummyImplementation < BookyUploader
  include ObjectStorage::Concern
  include ::RecordsUploads::Concern
  prepend ::ObjectStorage::Extension::RecordsUploads

  storage_options Booky.config.uploads

  private

  #
  # user/:id
  #
  def dynamic_segment
    File.join(model.class.to_s.underscore, model.id.to_s)
  end
end

describe ObjectStorage do
  let(:uploader_class)  { DummyImplementation }
  let(:object)          { build_stubbed(:user) }
  let(:uploader)        { uploader_class.new(object, :file) }

  describe '#object_store=' do
    before do
      allow(uploader_class).to receive(:object_store_enabled?).and_return(true)
    end

    it "reload the local storage" do
      uploader.object_store = described_class::Store::LOCAL

      expect(uploader.file_storage?).to be_truthy
    end

    context 'object_store is Store::LOCAL' do
      before do
        uploader.object_store = described_class::Store::LOCAL
      end

      describe '#store_dir' do
        it 'is the composition of (base_dir, dynamic_segment)' do
          expect(uploader.store_dir).to start_with("uploads/-/system/user/")
        end
      end
    end
  end

  describe '#file_cache_storage?' do
    context 'when file storage is used' do
      before do
        expect(uploader_class).to receive(:cache_storage) { CarrierWave::Storage::File }
      end

      it { expect(uploader).to be_file_cache_storage }
    end
  end

  # this means the model shall include
  #   include RecordsUpload::Concern
  #   prepend ObjectStorage::Extension::RecordsUploads
  # the object_store persistence is delegated to the `Upload` model.
  #
  context 'when persist_object_store? is false' do
    let(:object) { create(:user, :with_avatar) }
    let(:uploader) { object.avatar }

    it { expect(object).to be_a(Avatarable) }
    it { expect(uploader.persist_object_store?).to be_falsey }

    describe 'delegates the object_store logic to the `Upload` model' do
      it 'sets @upload to the found `upload`' do
        expect(uploader.upload).to eq(uploader.upload)
      end

      it 'sets @object_store to the `Upload` value' do
        expect(uploader.object_store).to eq(uploader.upload.store)
      end
    end
  end

  describe '#cache!' do
    subject { uploader.cache!(uploaded_file) }

    context 'when local file is used' do
      let(:uploaded_file) do
        fixture_file_upload('spec/fixtures/rails_sample.jpg', 'image/jpg')
      end

      before(:each) { subject }

      it { expect(uploader).to be_exists }

      it "properly caches the file" do
        expect(uploader.path).to start_with(uploader_class.root)
        expect(uploader.filename).to eq('rails_sample.jpg')
      end
    end

    context 'when local file is used' do
      let(:temp_file) { Tempfile.new("test") }

      before  { FileUtils.touch(temp_file) }
      after   { FileUtils.rm_f(temp_file) }

      context 'when valid file is used' do
        let(:uploaded_file) { temp_file }

        context 'when object storage and direct upload is not used' do
          before do
            stub_uploads_object_storage(uploader_class, enabled: true, direct_upload: false)
          end

          context 'when file is stored' do
            subject { uploader.store!(uploaded_file) }

            before(:each) { subject }

            it { expect(uploader).to be_exists }

            it { expect(uploader).not_to be_cached }

            it { expect(uploader).to be_file_storage }

            it { expect(uploader.path).not_to be_nil }

            it 'file to be remotely stored in permament location' do
              expect(uploader.path).not_to include('tmp/upload')
              expect(uploader.path).not_to include('tmp/cache')
              expect(uploader.object_store).to eq(described_class::Store::LOCAL)
            end
          end
        end
      end
    end
  end

  describe '#retrieve_from_store!' do
    let(:models)  { create_list(:user, 3, :with_avatar).map(&:reload) }
    let(:avatars) { models.map(&:avatar) }

    it 'batches fetching uploads from the database' do
      #
      # Ensure that these are all created and fully loaded before we start running queries for avatars
      #
      models

      expect { avatars }.not_to exceed_query_limit(1)
    end

    it 'fetches a unique upload for each model' do
      expect(avatars.map(&:url).uniq).to eq(avatars.map(&:url))
      expect(avatars.map(&:upload).uniq).to eq(avatars.map(&:upload))
    end
  end
end

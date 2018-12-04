require 'rails_helper'

describe AvatarUploader do
  let(:model)     { build_stubbed(:user) }
  let(:uploader)  { described_class.new(model, :avatar) }
  let(:upload)    { create(:upload, model: model) }

  subject { uploader }

  it_behaves_like 'builds correct paths',
                  store_dir: %r[uploads/-/system/user/avatar/],
                  upload_path: %r[uploads/-/system/user/avatar/],
                  absolute_path: %r[#{CarrierWave.root}/uploads/-/system/user/avatar/]

  context 'with a file' do
    let(:user)      { create(:user, :with_avatar) }
    let(:uploader)  { user.avatar }
    let(:upload)    { uploader.upload }

    before do
      stub_uploads_object_storage
    end

    it 'sets the right absolute path' do
      storage_path = Booky.config.uploads.storage_path
      absolute_path = File.join(storage_path, upload.path)

      expect(uploader.absolute_path.scan(storage_path).size).to eq(1)
      expect(uploader.absolute_path).to eq(absolute_path)
    end
  end
end

FactoryBot.define do
  factory :upload do
    model     { build(:user) }
    size      { 100.kilobytes }
    uploader  { 'AvatarUploader' }

    mount_point { :avatar }
    secret      { nil }
    store       { ObjectStorage::Store::LOCAL }

    #
    # this needs to comply with RecordsUpload::Concern#upload_path
    #
    path { File.join('uploads/-/system', model.class.to_s.underscore, mount_point.to_s, 'avatar.jpg') }
  end
end

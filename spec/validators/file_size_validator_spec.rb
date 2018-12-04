require 'rails_helper'

describe FileSizeValidator do
  let(:validator) { described_class.new(options) }
  let(:user)      { create(:user) }
  let(:avatar)    { AvatarUploader.new(user) }

  describe 'options uses an integer' do
    let(:options) { { maximum: 10, attributes: { avatar: avatar } } }

    it 'avatar exceeds maximum limit' do
      allow(avatar).to receive(:size) { 100 }
      validator.validate_each(user, :avatar, avatar)

      expect(user.errors).to have_key(:avatar)
    end

    it 'avatar under maximum limit' do
      allow(avatar).to receive(:size) { 1 }
      validator.validate_each(user, :avatar, avatar)

      expect(user.errors).not_to have_key(:avatar)
    end
  end
end

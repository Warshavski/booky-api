require 'rails_helper'

describe Avatarable do
  let(:user) { create(:user, :with_avatar) }

  let(:booky_host)        { 'https://booky.example.com' }
  let(:relative_url_root) { '/booky' }
  let(:asset_host)        { 'https://booky-assets.example.com' }

  before do
    stub_config_setting(base_url: booky_host)
    stub_config_setting(relative_url_root: relative_url_root)
  end

  describe '#update' do
    let(:validator) { user._validators[:avatar].detect { |v| v.is_a?(FileSizeValidator) } }

    context 'when avatar changed' do
      it 'validates the file size' do
        expect(validator).to receive(:validate_each).and_call_original

        user.update(avatar: 'uploads/avatar.png')
      end
    end

    context 'when avatar was not changed' do
      it 'skips validation of file size' do
        expect(validator).not_to receive(:validate_each)

        user.update(username: 'Hello world')
      end
    end
  end

  describe '#avatar_path' do
    using RSpec::Parameterized::TableSyntax

    where(:has_asset_host, :only_path, :avatar_path_prefix) do
      false | true  | [relative_url_root]
      false | false | [booky_host, relative_url_root]
    end

    with_them do
      before do
        allow(ActionController::Base).to receive(:asset_host) { has_asset_host && asset_host }
      end

      let(:avatar_path) { (avatar_path_prefix + [user.avatar.local_url]).join }

      it 'returns the expected avatar path' do
        expect(user.avatar_path(only_path: only_path)).to eq(avatar_path)
      end

      it 'returns the expected avatar path with width parameter' do
        expect(user.avatar_path(only_path: only_path, size: 128)).to eq(avatar_path + "?width=128")
      end
    end
  end
end

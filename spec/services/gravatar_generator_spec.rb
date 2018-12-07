require 'rails_helper'

describe GravatarGenerator do
  describe '#execute' do
    let(:url) { 'http://example.com/avatar?hash=%{hash}&size=%{size}&email=%{email}&username=%{username}' }

    before do
      allow(Booky.config.gravatar).to receive(:plain_url).and_return(url)
    end

    it 'replaces the placeholders' do
      avatar_url = described_class.new.execute('wat@so.yeah', 100, 2, username: 'user')

      inclusions = %W[
          hash=#{Digest::MD5.hexdigest('wat@so.yeah')}
          size=200
          email=wat%40so.yeah
          username=user
        ]

      inclusions.each { |expectation| expect(avatar_url).to include(expectation) }
    end
  end
end

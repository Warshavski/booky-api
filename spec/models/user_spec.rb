require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }

    it { should validate_uniqueness_of(:username) }

    it { should validate_length_of(:bio).is_at_most(255) }
  end

  describe 'user creation' do
    let(:user) { create(:user, username: 'wat_user') }

    it { expect(user.admin?).to be_falsey }
    it { expect(user.banned_at).to be_nil }
  end

  describe 'scopes' do
    describe '.by_username' do
      it 'finds users regardless of the case passed' do
        camel_user = create(:user, username: 'CaMeLcAsEd')
        upper_user = create(:user, username: 'UPPERCASE')

        result = described_class.by_username(%w[CAMELCASED uppercase])

        expect(result).to contain_exactly(camel_user, upper_user)
      end

      it 'finds a single user regardless of the case passed' do
        user = create(:user, username: 'CaMeLcAsEd')

        expect(described_class.by_username('CAMELCASED')).to contain_exactly(user)
      end
    end

    describe '.admins' do
      let_it_be(:user) { create(:user) }

      it 'returns only user with admin privileges' do
        admin = create(:admin)

        expect(described_class.admins).to eq([admin])
      end

      it 'returns nothing if admins not present' do
        expect(described_class.admins).to eq([])
      end
    end

    describe '.banned' do
      let_it_be(:user) { create(:user) }

      it 'returns only banned users' do
        banned_user = create(:user, banned_at: Time.now)

        expect(described_class.banned).to eq([banned_user])
      end

      it 'returns nothing if banned user not present' do
        expect(described_class.banned).to eq([])
      end
    end

    describe '.active' do
      let_it_be(:banned_user) { create(:user, banned_at: Time.now) }

      it 'returns only active users' do
        active_user = create(:user)

        expect(described_class.active).to eq([active_user])
      end

      it 'returns nothing if active user not present' do
        expect(described_class.active).to eq([])
      end
    end

    # TODO : add after authentication configurations
    #
    # describe '.confirmed' do
    #   let_it_be(:unconfirmed_user) { create(:user, confirmed_at: nil) }
    #
    #   it 'returns only user confirmed users' do
    #     user = create(:user)
    #
    #     expect(described_class.confirmed).to eq([user])
    #   end
    #
    #   it 'returns nothing if confirmed user not present' do
    #     expect(described_class.confirmed).to eq([])
    #   end
    # end
  end

  describe '.find_for_database_authentication' do
    it 'strips whitespace from login' do
      user = create(:user)

      expect(described_class.find_for_database_authentication(login: " #{user.username} ")).to eq user
    end
  end

  describe '#sort_by_attribute' do
    let_it_be(:user) do
      create(:user, created_at: Date.today, current_sign_in_at: Date.today, username: 'Alpha')
    end

    let_it_be(:user1) do
      create(:user, created_at: Date.today - 1.day, current_sign_in_at: Date.today - 1.day, username: 'Omega')
    end

    let_it_be(:user2) do
      create(:user, created_at: Date.today - 2.days, username: 'Beta')
    end

    context 'when sort by recent_sign_in' do
      subject { described_class.sort_by_attribute('recent_sign_in') }

      it 'sorts users by recent sign-in time' do
        expect(subject.first).to eq(user)
        expect(subject.second).to eq(user1)
      end

      it 'pushes users who never signed in to the end' do
        expect(subject.third).to eq(user2)
      end
    end

    context 'when sort by oldest_sign_in' do
      subject { described_class.sort_by_attribute('oldest_sign_in') }

      it 'sorts users by the oldest sign-in time' do
        expect(subject.first).to eq(user1)
        expect(subject.second).to eq(user)
      end

      it 'pushes users who never signed in to the end' do
        expect(subject.third).to eq(user2)
      end
    end

    it 'sorts users in descending order by their creation time' do
      expect(described_class.sort_by_attribute('created_desc').first).to eq(user)
    end

    it 'sorts users in ascending order by their creation time' do
      expect(described_class.sort_by_attribute('created_asc').first).to eq(user2)
    end

    it 'sorts users by id in descending order when nil is passed' do
      expect(described_class.sort_by_attribute(nil).first).to eq(user2)
    end
  end

  describe '.search' do
    subject { described_class.search(query) }

    let_it_be(:user) { create(:user, username: 'watusername', email: 'email@example.com') }

    context 'with a matching email' do
      let(:query) { user.email }

      it { is_expected.to eq([user]) }
    end

    context 'with a partially matching email' do
      let(:query) { user.email[0..2] }

      it { is_expected.to eq([user]) }
    end

    context 'with a matching email regardless of the casting' do
      let(:query) { user.email.upcase }

      it { is_expected.to eq([user]) }
    end

    context 'with a matching username' do
      let(:query) { user.username }

      it { is_expected.to eq([user]) }
    end

    context 'with a partially matching username' do
      let(:query) { user.username[0..2] }

      it { is_expected.to eq([user]) }
    end

    context 'with a matching username regardless of the casting' do
      let(:query) { user.username.upcase }

      it { is_expected.to eq([user]) }
    end

    context 'with a blank query' do
      let(:query) { '' }

      it { is_expected.to eq([]) }
    end
  end

  describe '.by_login' do
    let_it_be(:username) { 'John' }

    let_it_be(:user) { create(:user, username: username) }

    it 'finds user by email' do
      expect(described_class.by_login(user.email)).to eq(user)
    end

    it 'finds user by upcase email match' do
      expect(described_class.by_login(user.email.upcase)).to eq(user)
    end

    it 'finds user by username match' do
      expect(described_class.by_login(username)).to eq(user)
    end

    it 'finds user by username lowercase' do
      expect(described_class.by_login(username.downcase)).to eq(user)
    end

    it 'returns nil on nil login' do
      expect(described_class.by_login(nil)).to be_nil
    end

    it 'returns nil on empty login string' do
      expect(described_class.by_login('')).to be_nil
    end
  end

  describe '.find_by_username' do
    it 'returns nil if not found' do
      expect(described_class.find_by_username('JohnDoe')).to be_nil
    end

    it 'is case-insensitive' do
      user = create(:user, username: 'JohnDoe')

      expect(described_class.find_by_username('JOHNDOE')).to eq(user)
    end
  end

  describe '.find_by_username!' do
    it 'raises RecordNotFound' do
      expect { described_class.find_by_username!('JohnDoe') }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'is case-insensitive' do
      user = create(:user, username: 'JohnDoe')

      expect(described_class.find_by_username!('JOHNDOE')).to eq user
    end
  end

  describe '.where_not_in' do
    context 'without an argument' do
      it 'returns the current relation' do
        user = create(:user)

        expect(described_class.where_not_in).to eq([user])
      end
    end

    context 'using a list of user IDs' do
      it 'excludes the users from the returned relation' do
        user1 = create(:user)
        user2 = create(:user)

        expect(described_class.where_not_in([user2.id])).to eq([user1])
      end
    end
  end

  describe '.reorder_by_name' do
    it 'reorders the input relation' do
      user1 = create(:user, username: 'A')
      user2 = create(:user, username: 'B')

      expect(described_class.reorder_by_username).to eq([user1, user2])
    end
  end
end

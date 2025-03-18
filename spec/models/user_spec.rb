require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    context 'when username or email is duplicated' do
      before { create(:user, username: 'john_doe', email: 'john@example.com') }

      it 'is invalid with a duplicate username' do
        user = FactoryBot.build(:user, username: 'john_doe', email: 'another@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("has already been taken")
      end

      it 'is invalid with a duplicate email' do
        user = FactoryBot.build(:user, username: 'another_user', email: 'john@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("has already been taken")
      end
    end
  end

  context 'associations' do
    it { should have_many(:conversation_users) }
    it { should have_many(:conversations).through(:conversation_users) }
    it { should have_many(:messages).with_foreign_key('sender_id') }
  end

  context 'has_secure_password' do
    let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

    it 'encrypts the password' do
      expect(user.password_digest).not_to be_nil
    end

    it 'authenticates with the correct password' do
      expect(user.authenticate('password')).to eq(user)
    end

    it 'does not authenticate with an incorrect password' do
      expect(user.authenticate('wrong_password')).to be_falsey
    end
  end
end

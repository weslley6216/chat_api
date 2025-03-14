describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
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
    it { should have_many(:conversations_as_user_a).class_name(Conversation) }
    it { should have_many(:conversations_as_user_b).class_name(Conversation) }
  end
end

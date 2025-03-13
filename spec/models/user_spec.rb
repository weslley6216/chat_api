describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }

    context 'when username or email is duplicated' do
      before { create(:user, username: 'john_doe', email: 'john@example.com') }

      it 'is invalid with a duplicate username' do
        user = FactoryBot.build(:user, username: 'john_doe', email: 'another@example.com')
        expect(user).not_to be_valid
      end

      it 'is invalid with a duplicate email' do
        user = FactoryBot.build(:user, username: 'another_user', email: 'john@example.com')
        expect(user).not_to be_valid
      end
    end
  end
end

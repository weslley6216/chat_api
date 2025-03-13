require 'rails_helper'

RSpec.describe Message, type: :model do
  context 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:receiver) }
  end

  context 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
  end

  context 'when creating a message' do
    let(:sender) { FactoryBot.create(:user, username: 'sender_user', email: 'sender@example.com') }
    let(:receiver) { FactoryBot.create(:user, username: 'receiver_user', email: 'receiver@example.com') }

    it 'is valid with valid attributes' do
      message = FactoryBot.build(:message, sender: sender, receiver: receiver)
      expect(message).to be_valid
    end

    it 'is invalid without a content' do
      message = FactoryBot.build(:message, content: nil, sender: sender, receiver: receiver)
      expect(message).not_to be_valid
    end

    it 'is invalid without a sender' do
      message = FactoryBot.build(:message, sender: nil, receiver: receiver)
      expect(message).not_to be_valid
    end

    it 'is invalid without a receiver' do
      message = FactoryBot.build(:message, sender: sender, receiver: nil)
      expect(message).not_to be_valid
    end
  end
end

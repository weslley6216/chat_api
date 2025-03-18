require 'rails_helper'

describe Message, type: :model do
  context 'validations' do
    it { should validate_presence_of(:content) }
  end

  context 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
    it { should belong_to(:conversation) }
  end

  context 'when creating a message' do
    let(:sender) { create(:user, username: 'sender_user', email: 'sender@example.com') }
    let(:receiver) { create(:user, username: 'receiver_user', email: 'receiver@example.com') }
    let(:conversation) { create(:conversation, users: [ sender, receiver ]) }

    it 'is valid with valid attributes' do
      message = build(:message, sender: sender, receiver: receiver, conversation: conversation, content: 'Hello')
      expect(message).to be_valid
    end

    it 'is invalid without a content' do
      message = build(:message, content: nil, sender: sender, receiver: receiver, conversation: conversation)
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without a sender' do
      message = build(:message, sender: nil, receiver: receiver, conversation: conversation)
      expect(message).not_to be_valid
    end

    it 'is invalid without a receiver' do
      message = build(:message, sender: sender, receiver: nil, conversation: conversation)
      expect(message).not_to be_valid
    end

    it 'is invalid without a conversation' do
      message = build(:message, sender: sender, receiver: receiver, conversation: nil)
      expect(message).not_to be_valid
    end
  end
end

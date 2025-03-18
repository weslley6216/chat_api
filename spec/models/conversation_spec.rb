require 'rails_helper'

describe Conversation, type: :model do
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:conversation) { create(:conversation, users: [ user_one, user_two ]) }
  let(:message) { create(:message, conversation: conversation, sender: user_one) }

  context 'associations' do
    it { should have_many(:conversation_users) }
    it { should have_many(:users).through(:conversation_users) }
    it { should have_many(:messages) }
  end

  context '#display_name_for' do
    it 'returns the usernames of other users in the conversation' do
      expect(conversation.display_name_for(user_one)).to eq(user_two.username.capitalize)
      expect(conversation.display_name_for(user_two)).to eq(user_one.username.capitalize)
    end
  end

  context '.ordered_by_last_message' do
    it 'orders conversations by the last message created_at' do
      conversation2 = create(:conversation, users: [ user_one, create(:user) ])
      create(:message, conversation: conversation, sender: user_one, created_at: 1.day.ago)
      create(:message, conversation: conversation2, sender: user_one, created_at: Time.now)

      ordered_conversations = Conversation.ordered_by_last_message(user_one.id)

      expect(ordered_conversations).to eq([ conversation2, conversation ])
    end
  end
end

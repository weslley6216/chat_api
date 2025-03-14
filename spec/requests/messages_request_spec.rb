require 'rails_helper'

describe 'Messages', type: :request do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:conversation) { create(:conversation, user_a: user_a, user_b: user_b) }
  let(:message_params) { { sender_id: user_a.id, receiver_id: user_b.id, content: 'Hello' } }
  let(:message) { create(:message, conversation: conversation, sender: user_a, content: 'Hello') }

  describe 'GET /conversations/:conversation_id/messages' do
    it 'returns all messages for a conversation' do
      create(:message, conversation: conversation, sender: user_a, content: 'Hello')
      create(:message, conversation: conversation, receiver: user_b, content: 'Hi')

      get conversation_messages_path(conversation)

      expect(response).to have_http_status(:ok)
      expect(parsed_json.length).to eq(2)
      expect(parsed_json.first[:content]).to eq('Hello')
      expect(parsed_json.second[:content]).to eq('Hi')
    end
  end

  describe 'POST /conversations/:conversation_id/messages' do
    it 'creates a new message' do
      post conversation_messages_path(conversation), params: { message: message_params }

      expect(response).to have_http_status(:created)
      expect(parsed_json[:content]).to eq('Hello')
    end

    it 'returns error if message is invalid' do
      post conversation_messages_path(conversation), params: { message: { content: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /conversations/:conversation_id/messages/:id' do
    it 'updates an existing message' do
      patch conversation_message_path(conversation, message), params: { message: { content: 'Updated' } }

      expect(response).to have_http_status(:ok)
      expect(parsed_json[:content]).to eq('Updated')
    end
  end

  describe 'DELETE /conversations/:conversation_id/messages/:id' do
    it 'deletes a message' do
      delete conversation_message_path(conversation, message)

      expect(response).to have_http_status(:no_content)
      expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

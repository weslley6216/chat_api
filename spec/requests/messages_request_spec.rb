require 'rails_helper'

describe 'Messages', type: :request do
  let(:auth_headers) { auth_token_header(user_one) }
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_three) { create(:user) }
  let(:conversation) { create(:conversation, users: [ user_one, user_two ]) }
  let(:message_params) { { content: 'Hello' } }
  let(:message) { create(:message, conversation: conversation, sender: user_one, content: 'Hello') }

  describe 'GET /conversations/:conversation_id/messages' do
    it 'returns all messages for a conversation' do
      create(:message, conversation: conversation, sender: user_one, content: 'Hello')
      create(:message, conversation: conversation, sender: user_two, content: 'Hi')

      get conversation_messages_path(conversation), headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json.length).to eq(2)
      expect(parsed_json.first[:content]).to eq('Hello')
      expect(parsed_json.second[:content]).to eq('Hi')
    end

    it 'returns empty array if no messages' do
      conversation2 = create(:conversation, users: [ user_one, user_three ])
      get conversation_messages_path(conversation2), headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json.length).to eq(0)
    end

    it 'returns 403 if user is not in conversation' do
      conversation2 = create(:conversation, users: [create(:user), create(:user)])
      get conversation_messages_path(conversation2), headers: auth_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /conversations/:conversation_id/messages' do
    it 'creates a new message' do
      post conversation_messages_path(conversation),
           params: { message: message_params },
           headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(parsed_json[:content]).to eq('Hello')
    end

    it 'returns error if message is invalid' do
      post conversation_messages_path(conversation),
           params: { message: { content: nil } },
           headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns 403 if user is not in conversation' do
      conversation2 = create(:conversation, users: [create(:user), create(:user)])
      post conversation_messages_path(conversation2),
           params: { message: message_params },
           headers: auth_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PATCH /conversations/:conversation_id/messages/:id' do
    it 'updates an existing message' do
      patch conversation_message_path(conversation, message),
            params: { message: { content: 'Updated' } },
            headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json[:content]).to eq('Updated')
    end

    it 'returns 403 if user is not in conversation' do
      conversation2 = create(:conversation, users: [create(:user), create(:user)])
      message2 = create(:message, conversation: conversation2, sender: create(:user))
      patch conversation_message_path(conversation2, message2),
            params: { message: { content: 'Updated' } },
            headers: auth_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /conversations/:conversation_id/messages/:id' do
    it 'deletes a message' do
      delete conversation_message_path(conversation, message), headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns 403 if user is not in conversation' do
      conversation2 = create(:conversation, users: [create(:user), create(:user)])
      message2 = create(:message, conversation: conversation2, sender: create(:user))
      delete conversation_message_path(conversation2, message2), headers: auth_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end

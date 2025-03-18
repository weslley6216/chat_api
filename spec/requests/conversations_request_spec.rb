require 'rails_helper'

describe 'Conversations API', type: :request do
  let(:auth_headers) { auth_token_header(user_one) }
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_three) { create(:user) }
  let(:conversation) { create(:conversation, users: [ user_one, user_two ]) }

  context 'GET /conversations' do
    it 'returns all conversations' do
      create_list(:conversation, 3, :with_messages, users: [ user_one, create(:user) ])

      get conversations_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json.length).to eq(3)
    end
  end

  context 'GET /conversations/:id' do
    it 'returns a specific conversation' do
      conversation = create(:conversation, users: [ user_one, create(:user) ])

      get conversation_path(conversation), headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json[:id]).to eq(conversation.id)
    end

    it 'returns 404 if conversation not found' do
      get conversation_path(999), headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 403 if user is not in conversation' do
      other_conversation = create(:conversation, users: [ user_three, create(:user) ])
      get conversation_path(other_conversation), headers: auth_headers

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'POST /conversations' do
    let(:conversation_params) { { user_id: user_two.id } }

    it 'creates a new conversation' do
      post conversations_path,
           params: { conversation: conversation_params },
           headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(Conversation.last.users).to include(user_one, user_two)
    end

    it 'returns error if parameters are invalid' do
      post conversations_path,
           params: { conversation: { user_id: nil } },
           headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'DELETE /conversations/:id' do
    it 'deletes a conversation' do
      delete conversation_path(conversation), headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect { conversation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns 403 if user is not in conversation' do
      other_conversation = create(:conversation, users: [user_three, create(:user)])
      delete conversation_path(other_conversation), headers: auth_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end

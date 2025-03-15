require 'rails_helper'

describe 'Conversations API', type: :request do
  let(:auth_headers) { auth_token_header(user_a) }
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:conversation) { create(:conversation, user_a: user_a, user_b: user_b) }

  describe 'GET /conversations' do
    it 'returns all conversations' do
      create_list(:conversation, 3, user_a: user_a)

      get conversations_path, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json.length).to eq(3)
    end
  end

  describe 'GET /conversations/:id' do
    it 'returns a specific conversation' do
      get conversation_path(conversation), headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(parsed_json[:id]).to eq(conversation.id)
    end

    it 'returns 404 if conversation not found' do
      get conversation_path(999), headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /conversations' do
    let(:conversation_params) { { user_a_id: user_a.id, user_b_id: user_b.id } }

    it 'creates a new conversation' do
      post conversations_path,
           params: { conversation: conversation_params },
           headers: auth_headers

      expect(response).to have_http_status(:created)
      expect(parsed_json[:user_a_id]).to eq(user_a.id)
      expect(parsed_json[:user_b_id]).to eq(user_b.id)
    end

    it 'returns error if parameters are invalid' do
      post conversations_path,
           params: { conversation: { user_a_id: nil, user_b_id: nil } },
           headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /conversations/:id' do
    it 'deletes a conversation' do
      delete conversation_path(conversation), headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect { conversation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

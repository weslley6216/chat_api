require 'rails_helper'

describe 'Authentication', type: :request do
  before do
    create(:user, email: 'user@example.com', username: 'username_example', password: 'password')
  end

  describe 'POST /login' do
    context 'when valid credentials' do
      it 'returns a token when using email' do
        post '/login', params: { email: 'user@example.com', password: 'password' }

        expect(response).to have_http_status(:ok)
        expect(parsed_json[:token]).to be_present
      end

      it 'returns a token when using username' do
        post '/login', params: { username: 'username_example', password: 'password' }

        expect(response).to have_http_status(:ok)
        expect(parsed_json[:token]).to be_present
      end
    end

    context 'when invalid credentials' do
      it 'returns an error message for invalid email' do
        post '/login', params: { email: 'user@example.com', password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_json[:error]).to eq('Invalid email, username or password')
      end

      it 'returns an error message for invalid username' do
        post '/login', params: { username: 'username_example', password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_json[:error]).to eq('Invalid email, username or password')
      end
    end
  end
end

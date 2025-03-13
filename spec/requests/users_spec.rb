require 'rails_helper'

describe 'Users', type: :request do
  describe 'POST /users' do
    it 'creates a new user' do
      user_params = { username: 'john_doe', email: 'john@example.com' }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:created)
      expect(parsed_json[:username]).to eq('john_doe')
      expect(parsed_json[:email]).to eq('john@example.com')
    end

    it 'returns an error if invalid' do
      user_params = { username: '', email: 'invalid_email' }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to eq([ "Username can't be blank", 'Email is invalid' ])
    end
  end
end

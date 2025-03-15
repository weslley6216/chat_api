require 'rails_helper'

describe 'Users', type: :request do
  describe 'POST /users' do
    it 'creates a new user' do
      user_params = {
        username: 'john_doe',
        email: 'john@example.com',
        password: '123456',
        password_confirmation: '123456'
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:created)
      expect(parsed_json[:username]).to eq('john_doe')
      expect(parsed_json[:email]).to eq('john@example.com')
    end

    it 'returns an error if username is blank' do
      user_params = {
        username: '',
        email: 'john@example.com',
        password: '123456',
        password_confirmation: '123456'
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to include("Username can't be blank")
    end

    it 'returns an error if email is invalid' do
      user_params = {
        username: 'john_doe',
        email: 'invalid_email',
        password: '123456',
        password_confirmation: '123456'
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to include('Email is invalid')
    end

    it 'returns an error if password is too short' do
      user_params = {
        username: 'john_doe',
        email: 'john@example.com',
        password: '123',
        password_confirmation: '123'
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to include('Password is too short (minimum is 6 characters)')
    end

    it 'returns an error if password confirmation does not match' do
      user_params = {
        username: 'john_doe',
        email: 'john@example.com',
        password: '123456',
        password_confirmation: '654321'
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to include("Password confirmation doesn't match Password")
    end

    it 'returns an error if email is already taken' do
      create(:user, email: 'john@example.com')

      user_params = {
        username: 'new_user',
        email: 'john@example.com',
        password: '123456',
        password_confirmation: '123456'
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to include('Email has already been taken')
    end

    it 'returns an error if required parameters are missing' do
      user_params = {
        username: 'john_doe',
        email: ''
      }

      post '/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_json[:errors]).to include("Email can't be blank")
    end
  end
end

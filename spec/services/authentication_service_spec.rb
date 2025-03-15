require 'rails_helper'

describe AuthenticationService, type: :service do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  describe '.encode' do
    it 'encodes the user ID into a JWT token' do
      token = AuthenticationService.encode(user_id: user.id)

      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base).first
      expect(decoded_token['user_id']).to eq(user.id)
    end
  end

  describe '.decode' do
    it 'decodes a valid JWT token' do
      token = AuthenticationService.encode(user_id: user.id)
      decoded = AuthenticationService.decode(token)

      expect(decoded).to be_a(HashWithIndifferentAccess)
      expect(decoded['user_id']).to eq(user.id)
    end

    it 'returns nil for an invalid JWT token' do
      invalid_token = 'invalid.token'
      decoded = AuthenticationService.decode(invalid_token)

      expect(decoded).to be_nil
    end
  end
end

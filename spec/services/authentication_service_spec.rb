require 'rails_helper'

describe AuthenticationService, type: :service do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  context '.encode' do
    it 'encodes the user ID into a JWT token' do
      payload = { user_id: user.id }
      token = AuthenticationService.encode(payload)

      decoded_token = JWT.decode(token, ENV['SECRET_KEY_BASE'], true, algorithm: 'HS256').first

      expect(decoded_token['user_id']).to eq(user.id)
    end
  end

  context '.decode' do
    it 'decodes a valid JWT token' do
      payload = { user_id: user.id }
      token = AuthenticationService.encode(payload)

      decoded = AuthenticationService.decode(token)

      expect(decoded).to be_a(HashWithIndifferentAccess)
      expect(decoded['user_id']).to eq(user.id)
    end

    it 'returns nil for an invalid JWT token' do
      invalid_token = 'invalid.token'

      decoded = AuthenticationService.decode(invalid_token)

      expect(decoded).to be_nil
    end

    it 'returns nil when the token is expired' do
      expired_token = AuthenticationService.encode({ user_id: user.id }, exp: 1.second.ago)

      decoded = AuthenticationService.decode(expired_token)

      expect(decoded).to be_nil
    end

    it 'logs an error for an invalid JWT token' do
      allow(Rails.logger).to receive(:error)
      invalid_token = 'invalid.token'

      AuthenticationService.decode(invalid_token)

      expect(Rails.logger).to have_received(:error).with(/JWT Decode Error/)
    end

    it 'logs an error for an expired JWT token' do
      allow(Rails.logger).to receive(:error)
      expired_token = AuthenticationService.encode({ user_id: user.id }, exp: 1.second.ago)

      AuthenticationService.decode(expired_token)

      expect(Rails.logger).to have_received(:error).with(/JWT Decode Error: Signature has expired/)
    end

     it 'logs an error for unexpected JWT error' do
      allow(Rails.logger).to receive(:error)
      allow(JWT).to receive(:decode).and_raise(StandardError, 'Unexpected JWT Error')

      AuthenticationService.decode('some.token')

      expect(Rails.logger).to have_received(:error).with(/Unexpected JWT Error/)
    end
  end
end

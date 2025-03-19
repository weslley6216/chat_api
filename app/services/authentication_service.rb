class AuthenticationService
  SECRET_KEY = ENV.fetch('SECRET_KEY_BASE')
  ALGORITHM = 'HS256'.freeze

  class << self
    def encode(payload, exp: 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY, ALGORITHM)
    end

    def decode(token)
      decoded_payload, = JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)
      HashWithIndifferentAccess.new(decoded_payload)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil
    rescue StandardError => e
      Rails.logger.error("Unexpected JWT Error: #{e.message}")
      nil
    end
  end
end

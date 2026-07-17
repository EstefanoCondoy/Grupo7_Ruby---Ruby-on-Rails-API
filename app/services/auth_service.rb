class AuthService
  ALGORITHM = 'HS256'

  class << self
    def encode(payload)
      expiration = ENV.fetch('JWT_EXPIRATION_HOURS', 24).to_i.hours.from_now.to_i
      payload_with_exp = payload.merge(exp: expiration)
      JWT.encode(payload_with_exp, secret_key, ALGORITHM)
    end

    def decode(token)
      decoded = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)
      HashWithIndifferentAccess.new(decoded.first)
    rescue JWT::ExpiredSignature
      raise ExceptionHandler::TokenExpired, 'El token ha expirado'
    rescue JWT::DecodeError
      raise ExceptionHandler::InvalidToken, 'Token inválido'
    end

    private

    def secret_key
      ENV.fetch('JWT_SECRET_KEY', 'default_secret_key_change_me')
    end
  end
end

class UserService
  class << self
    def register(params)
      user = User.new(params)
      user.save!
      user
    end

    def authenticate(email, password)
      user = User.find_by(email: email&.downcase)
      raise ExceptionHandler::AuthenticationError, 'Credenciales inválidas' unless user&.authenticate(password)

      token = AuthService.encode(user_id: user.id)
      { user: user, token: token }
    end

    def find_by_id(id)
      User.find(id)
    end

    def update(id, params)
      user = User.find(id)
      user.update!(params)
      user
    end

    def delete(id)
      user = User.find(id)
      user.destroy!
    end
  end
end

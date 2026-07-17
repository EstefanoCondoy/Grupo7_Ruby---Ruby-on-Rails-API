class UserSerializer
  def self.serialize(user)
    {
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      createdAt: user.created_at&.iso8601,
      updatedAt: user.updated_at&.iso8601
    }
  end

  def self.serialize_with_token(user, token)
    serialize(user).merge(token: token)
  end
end

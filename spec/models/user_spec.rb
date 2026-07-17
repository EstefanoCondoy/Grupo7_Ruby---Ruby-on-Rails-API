require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validaciones' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should have_secure_password }
  end

  describe 'asociaciones' do
    it { should have_many(:receipts).dependent(:destroy) }
  end

  describe 'normalización de email' do
    it 'convierte el email a minúsculas antes de guardar' do
      user = create(:user, email: 'TEST@EXAMPLE.COM')
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'cifrado de contraseña' do
    it 'almacena la contraseña cifrada con BCrypt' do
      user = create(:user, password: 'password123')
      expect(user.password_digest).not_to eq('password123')
      expect(user.authenticate('password123')).to be_truthy
    end
  end
end

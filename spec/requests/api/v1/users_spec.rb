require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:valid_attributes) do
    {
      user: {
        first_name: 'Estéfano',
        last_name: 'Condoy',
        email: 'estefano@test.com',
        password: 'password123'
      }
    }
  end

  describe 'POST /api/v1/users/register' do
    it 'registra un nuevo usuario' do
      post '/api/v1/users/register', params: valid_attributes
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['success']).to be true
      expect(json['data']['email']).to eq('estefano@test.com')
      expect(json['data']).not_to have_key('password_digest')
      expect(json['data']).not_to have_key('password')
    end

    it 'rechaza registro con email duplicado' do
      create(:user, email: 'estefano@test.com')
      post '/api/v1/users/register', params: valid_attributes
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/users/login' do
    let!(:user) { create(:user, email: 'estefano@test.com', password: 'password123') }

    it 'retorna un token JWT al autenticarse correctamente' do
      post '/api/v1/users/login', params: { email: 'estefano@test.com', password: 'password123' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['token']).to be_present
    end

    it 'rechaza credenciales inválidas' do
      post '/api/v1/users/login', params: { email: 'juan@example.com', password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

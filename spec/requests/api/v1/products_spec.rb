require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let(:user) { create(:user) }
  let(:token) { AuthService.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/products' do
    before { create_list(:product, 10) }

    it 'retorna la lista de productos' do
      get '/api/v1/products'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['success']).to be true
      expect(json['data'].length).to eq(10)
      expect(json['meta']).to have_key('totalCount')
    end
  end

  describe 'POST /api/v1/products' do
    let(:valid_params) do
      {
        product: {
          name: 'Laptop Test',
          description: 'Una laptop de prueba',
          price: 999.99,
          stock: 10
        }
      }
    end

    it 'crea un producto con autenticación' do
      post '/api/v1/products', params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['data']['name']).to eq('Laptop Test')
    end

    it 'rechaza creación sin autenticación' do
      post '/api/v1/products', params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

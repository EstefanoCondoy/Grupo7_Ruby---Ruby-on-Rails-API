require 'rails_helper'

RSpec.describe 'Api::V1::Receipts', type: :request do
  let(:user) { create(:user) }
  let(:token) { AuthService.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let!(:product1) { create(:product, price: 100.00, stock: 50) }
  let!(:product2) { create(:product, price: 200.00, stock: 30) }

  describe 'POST /api/v1/receipts' do
    let(:valid_params) do
      {
        receipt: {
          user_id: user.id,
          items: [
            { product_id: product1.id, quantity: 2 },
            { product_id: product2.id, quantity: 1 }
          ]
        }
      }
    end

    it 'crea un recibo calculando el total en el backend' do
      post '/api/v1/receipts', params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['data']['total']).to eq(400.0)
      expect(json['data']['items'].length).to eq(2)
    end

    it 'descuenta el stock automáticamente' do
      post '/api/v1/receipts', params: valid_params, headers: headers
      expect(product1.reload.stock).to eq(48)
      expect(product2.reload.stock).to eq(29)
    end

    it 'rechaza recibo si no hay stock suficiente' do
      params = {
        receipt: {
          user_id: user.id,
          items: [{ product_id: product1.id, quantity: 999 }]
        }
      }
      post '/api/v1/receipts', params: params, headers: headers
      expect(response).to have_http_status(:conflict)
    end

    it 'rechaza recibo sin autenticación' do
      post '/api/v1/receipts', params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/v1/receipts/user/:user_id' do
    it 'retorna recibos del usuario' do
      receipt = Receipt.create!(user: user, total: 100)
      get "/api/v1/receipts/user/#{user.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(1)
    end
  end
end

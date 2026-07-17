Rails.application.routes.draw do
  # Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      # Users
      post 'users/register', to: 'users#register'
      post 'users/login',    to: 'users#login'
      get    'users/:id',    to: 'users#show'
      put    'users/:id',    to: 'users#update'
      delete 'users/:id',    to: 'users#destroy'

      # Products
      resources :products, only: [:index, :show, :create, :update, :destroy]

      # Receipts
      post   'receipts',              to: 'receipts#create'
      get    'receipts',              to: 'receipts#index'
      get    'receipts/:id',          to: 'receipts#show'
      get    'receipts/user/:user_id', to: 'receipts#by_user'
      delete 'receipts/:id',          to: 'receipts#destroy'
    end
  end

  # Health check
  get 'health', to: proc { [200, {}, [{ status: 'ok', service: 'E-Commerce API Grupo 7' }.to_json]] }
end

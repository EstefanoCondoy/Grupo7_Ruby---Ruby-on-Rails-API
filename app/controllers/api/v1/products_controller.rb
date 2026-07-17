module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authorize_request, only: [:create, :update, :destroy]

      # GET /api/v1/products
      def index
        products = ProductService.find_all(
          page: params[:page] || 1,
          per_page: params[:per_page] || 10,
          name: params[:name]
        )
        render json: {
          success: true,
          data: ProductSerializer.serialize_collection(products),
          meta: {
            currentPage: products.current_page,
            totalPages: products.total_pages,
            totalCount: products.total_count,
            perPage: products.limit_value
          }
        }
      end

      # GET /api/v1/products/:id
      def show
        product = ProductService.find_by_id(params[:id])
        json_response(ProductSerializer.serialize(product))
      end

      # POST /api/v1/products
      def create
        product = ProductService.create(product_params)
        json_response(ProductSerializer.serialize(product), :created)
      end

      # PUT /api/v1/products/:id
      def update
        product = ProductService.update(params[:id], product_params)
        json_response(ProductSerializer.serialize(product))
      end

      # DELETE /api/v1/products/:id
      def destroy
        ProductService.delete(params[:id])
        json_response({ message: 'Producto eliminado exitosamente' })
      end

      private

      def product_params
        params.require(:product).permit(:name, :description, :price, :stock)
      end
    end
  end
end

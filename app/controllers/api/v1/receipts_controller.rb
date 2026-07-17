module Api
  module V1
    class ReceiptsController < ApplicationController
      before_action :authorize_request

      # POST /api/v1/receipts
      def create
        receipt = ReceiptService.create(
          receipt_params[:user_id],
          receipt_params[:items]
        )
        json_response(ReceiptSerializer.serialize(receipt), :created)
      end

      # GET /api/v1/receipts
      def index
        receipts = ReceiptService.find_all
        json_response(ReceiptSerializer.serialize_collection(receipts))
      end

      # GET /api/v1/receipts/:id
      def show
        receipt = ReceiptService.find_by_id(params[:id])
        json_response(ReceiptSerializer.serialize(receipt))
      end

      # GET /api/v1/receipts/user/:user_id
      def by_user
        receipts = ReceiptService.find_by_user(params[:user_id])
        json_response(ReceiptSerializer.serialize_collection(receipts))
      end

      # DELETE /api/v1/receipts/:id
      def destroy
        ReceiptService.delete(params[:id])
        json_response({ message: 'Recibo eliminado exitosamente' })
      end

      private

      def receipt_params
        params.require(:receipt).permit(:user_id, items: [:product_id, :quantity])
      end
    end
  end
end

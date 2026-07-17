module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, only: [:show, :update, :destroy]

      # POST /api/v1/users/register
      def register
        user = UserService.register(user_params)
        json_response(UserSerializer.serialize(user), :created)
      end

      # POST /api/v1/users/login
      def login
        result = UserService.authenticate(params[:email], params[:password])
        json_response(UserSerializer.serialize_with_token(result[:user], result[:token]))
      end

      # GET /api/v1/users/:id
      def show
        user = UserService.find_by_id(params[:id])
        json_response(UserSerializer.serialize(user))
      end

      # PUT /api/v1/users/:id
      def update
        user = UserService.update(params[:id], user_update_params)
        json_response(UserSerializer.serialize(user))
      end

      # DELETE /api/v1/users/:id
      def destroy
        UserService.delete(params[:id])
        json_response({ message: 'Usuario eliminado exitosamente' })
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
      end

      def user_update_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
      end
    end
  end
end

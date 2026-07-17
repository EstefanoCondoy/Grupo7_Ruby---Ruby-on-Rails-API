class ApplicationController < ActionController::API
  include ExceptionHandler

  private

  # Método para autenticar peticiones con JWT
  def authorize_request
    header = request.headers['Authorization']
    raise ExceptionHandler::InvalidToken, 'Token de autorización no proporcionado' unless header

    token = header.split(' ').last
    decoded = AuthService.decode(token)
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::InvalidToken, 'Usuario del token no encontrado'
  end

  # Helper para respuestas JSON estandarizadas
  def json_response(data, status = :ok, meta = {})
    response_body = { success: true, data: data }
    response_body[:meta] = meta unless meta.empty?
    render json: response_body, status: status
  end
end

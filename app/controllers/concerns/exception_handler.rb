module ExceptionHandler
  extend ActiveSupport::Concern

  # Excepciones personalizadas
  class AuthenticationError < StandardError; end
  class TokenExpired < StandardError; end
  class InvalidToken < StandardError; end
  class ValidationError < StandardError; end
  class InsufficientStockError < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::TokenExpired, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::ValidationError, with: :unprocessable_entity_response
    rescue_from ExceptionHandler::InsufficientStockError, with: :conflict_response

    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_response
    rescue_from ActiveRecord::RecordNotDestroyed, with: :unprocessable_entity_response
    rescue_from ActionController::ParameterMissing, with: :bad_request_response
  end

  private

  def not_found_response(exception)
    render json: error_response('Recurso no encontrado', exception.message, :not_found), status: :not_found
  end

  def unauthorized_request(exception)
    render json: error_response('No autorizado', exception.message, :unauthorized), status: :unauthorized
  end

  def record_invalid_response(exception)
    messages = exception.record.errors.full_messages
    render json: error_response('Error de validación', messages, :unprocessable_entity), status: :unprocessable_entity
  end

  def unprocessable_entity_response(exception)
    render json: error_response('Error de validación', exception.message, :unprocessable_entity), status: :unprocessable_entity
  end

  def conflict_response(exception)
    render json: error_response('Conflicto', exception.message, :conflict), status: :conflict
  end

  def bad_request_response(exception)
    render json: error_response('Solicitud inválida', exception.message, :bad_request), status: :bad_request
  end

  def error_response(error, details, status)
    {
      success: false,
      error: error,
      message: details,
      status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
      timestamp: Time.current.iso8601
    }
  end
end

class ErrorsController < ApplicationController
  def service_unavailable
    render json: {
      status: 503,
      error: :service_temporarily_unavailable,
      message: 'Please try again later'
    }, status: 503
  end

  def internal_server_error
    render json: {
      status: 500,
      error: :internal_server_error,
      message: 'Please check your address is correct'
    }, status: 500
  end
end

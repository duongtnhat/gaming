class ApplicationController < ActionController::API
  DEFAULT_PAGE_LIMIT = 5
  def success data, serializer
    data = serializer.new(data)
    render json: response_format(data, 200, "success"), status: 200
  end

  def error data, status, message
    render json: response_format(data, status, message), status: status
  end

  def response_format data, status, message
    {
      status: status,
      message: message,
    }.merge(data)
  end

  def current_user
    @current_user ||= current_devise_api_token&.resource_owner
  end
end

class ApplicationController < ActionController::API
  # after_filter :cors_set_access_control_headers

  DEFAULT_PAGE_LIMIT = 5
  def success data, serializer
    data = serializer.new(data)
    render json: response_format(data, 200, "success"), status: 200
  end

  def response_success data
    render json: response_format(data, 200, "success"), status: 200
  end

  def error data, status, message
    render json: response_format(data, status, message), status: status
  end

  def not_found
    render json: response_format({}, 404, "Not found"), status: 404
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

  # def cors_set_access_control_headers
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Allow-Methods'] = '*'
  #   headers['Access-Control-Allow-Headers'] = '*'
  #   headers['Access-Control-Max-Age'] = "1728000"
  # end
end

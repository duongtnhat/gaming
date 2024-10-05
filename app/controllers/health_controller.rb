class HealthController < ActionController::API
  def health
    render plain: "health", status: 200
  end
end

class ConfigController < ApplicationController
  def index
    data = Config.joins(:config_set).where(config_set: {code: "DISPLAY"}).pluck(:key, :value).to_h
    render json: response_format(data, 200, "success"), status: 200
  end
end

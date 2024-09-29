class Config < ApplicationRecord
  belongs_to :config_set

  def self.get_config key, default
    config = Config.find_by_key key
    return default if config.blank? || config.value.blank?
    config.value
  end
end

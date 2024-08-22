require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gaming
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.api_only = true

    config.active_record.encryption.primary_key = "jCiomuccXDg4kkCGDZ3gNGSVU1N1iKw8"
    config.active_record.encryption.deterministic_key = "R0c4SmTofxtIhQhYVNI1qoHYbROJBke7"
    config.active_record.encryption.key_derivation_salt = "yOUrYIeTyIHR3WY46HShDBd570sEt09Y"
  end
end

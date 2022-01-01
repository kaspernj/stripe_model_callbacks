require_relative "boot"

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"
require "sprockets/railtie" unless Gem.loaded_specs["rails"].version.to_s.start_with?("7.")

Bundler.require(*Rails.groups)
require "stripe_model_callbacks"

module Dummy; end

class Dummy::Application < Rails::Application
  # Initialize configuration defaults for originally generated Rails version.
  if Gem.loaded_specs["rails"].version.to_s.start_with?("7.")
    puts "LOAD 7 DEFAULTS"
    config.load_defaults 7.0
  else
    puts "LOAD 6 DEFAULTS"
    config.load_defaults 6.0
  end

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
end

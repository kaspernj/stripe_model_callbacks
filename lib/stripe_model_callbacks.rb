require "active_record_auditable"
require "auto_autoloader"
require "money-rails"
require "service_pattern"
require "stripe"
require "stripe_event"
require "stripe_model_callbacks/engine"
require "stripe_model_callbacks/autoload_models"
require "with_advisory_lock"

module StripeModelCallbacks
  path = "#{File.dirname(__FILE__)}/stripe_model_callbacks"

  autoload :Configuration, "#{path}/configuration"
  autoload :EventMocker, "#{path}/event_mocker"

  def self.configure
    yield StripeModelCallbacks::Configuration.current
  end
end

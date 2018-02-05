require "auto_autoloader"
require "exception_notifier"
require "money-rails"
require "public_activity"
require "service_pattern"
require "stripe"
require "stripe_event"
require "stripe_model_callbacks/engine"

module StripeModelCallbacks
  AutoAutoloader.autoload_sub_classes(self, __FILE__)
end

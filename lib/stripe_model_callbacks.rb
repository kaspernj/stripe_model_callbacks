require "auto_autoloader"
require "service_pattern"
require "stripe_model_callbacks/engine"

module StripeModelCallbacks
  AutoAutoloader.autoload_sub_classes(self, __FILE__)
end

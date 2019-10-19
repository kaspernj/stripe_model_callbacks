$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "stripe_model_callbacks/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stripe_model_callbacks"
  s.version     = StripeModelCallbacks::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["kaspernj@gmail.com"]
  s.homepage    = "https://github.com/kaspernj/stripe_model_callbacks"
  s.summary     = "Framework for getting Stripe webhook callbacks directly to your models"
  s.description = "Framework for getting Stripe webhook callbacks directly to your models"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"
  s.add_runtime_dependency "money-rails"
  s.add_runtime_dependency "public_activity"
  s.add_runtime_dependency "service_pattern"
  s.add_runtime_dependency "stripe"
  s.add_runtime_dependency "stripe-ruby-mock"
  s.add_runtime_dependency "stripe_event", ">= 0.0.4"
end

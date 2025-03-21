$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "stripe_model_callbacks/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "stripe_model_callbacks"
  s.version = StripeModelCallbacks::VERSION
  s.authors = ["kaspernj"]
  s.email = ["kaspernj@gmail.com"]
  s.homepage = "https://github.com/kaspernj/stripe_model_callbacks"
  s.summary = "Framework for getting Stripe webhook callbacks directly to your models"
  s.description = "Framework for getting Stripe webhook callbacks directly to your models"
  s.license = "MIT"
  s.required_ruby_version = ">= 3.3"
  s.metadata["rubygems_mfa_required"] = "true"
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 7.0.0"

  s.add_runtime_dependency "active_record_auditable"
  s.add_runtime_dependency "auto_autoloader"
  s.add_runtime_dependency "money-rails"
  s.add_runtime_dependency "service_pattern", ">= 1.0.5"
  s.add_runtime_dependency "stripe"
  s.add_runtime_dependency "stripe_event", ">= 0.0.4"
  s.add_runtime_dependency "with_advisory_lock", ">= 4.6.0"
end

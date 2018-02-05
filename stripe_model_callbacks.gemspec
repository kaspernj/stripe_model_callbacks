$LOAD_PATH.push File.expand_path("../lib", __FILE__)

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
  s.add_runtime_dependency "auto_autoloader", ">= 0.0.5"
  s.add_runtime_dependency "service_pattern", ">= 0.0.3"
  s.add_runtime_dependency "stripe", ">= 3.9.1"
  s.add_runtime_dependency "stripe_event", ">= 2.1.1"

  s.add_development_dependency "best_practice_project", "0.0.10"
  s.add_development_dependency "capybara", "2.13.0"
  s.add_development_dependency "capybara-webkit", "1.14.0"
  s.add_development_dependency "factory_bot_rails", "4.8.2"
  s.add_development_dependency "rails_best_practices", "1.19.0"
  s.add_development_dependency "rspec-rails", "3.7.2"
  s.add_development_dependency "rubocop", "0.52.1"
  s.add_development_dependency "sqlite3", "1.3.13"
end

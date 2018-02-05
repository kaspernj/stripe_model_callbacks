Rails.application.routes.draw do
  mount StripeModelCallbacks::Engine => "/stripe_model_callbacks"
end

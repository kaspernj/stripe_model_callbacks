Rails.application.routes.draw do
  mount StripeEvent::Engine => "/stripe-events"
  mount StripeModelCallbacks::Engine => "/stripe_model_callbacks"
end

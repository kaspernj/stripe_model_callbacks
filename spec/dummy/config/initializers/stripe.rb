Rails.application.reloader.to_prepare do
  Stripe.api_key = "fake-key"
  StripeEvent.signing_secret = "fake-signing-key"

  Rails.configuration.stripe = {
    publishable_key: "fake-public-key",
    secret_key: "fake-secret-key"
  }

  StripeEvent.configure do |events|
    StripeModelCallbacks::ConfigureService.execute!(events:)
  end
end

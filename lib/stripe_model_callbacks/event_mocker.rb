module StripeModelCallbacks::EventMocker
  def mock_stripe_event(name, args = nil)
    StripeModelCallbacks::EventMockerService.execute!(name:, scope: self, args:)
  end
end

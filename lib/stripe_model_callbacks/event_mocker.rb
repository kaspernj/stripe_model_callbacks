module StripeModelCallbacks::EventMocker
  def mock_stripe_event(name, args = nil)
    StripeModelCallbacks::EventMockerService.execute!(name: name, scope: self, args: args)
  end
end

module StripeModelCallbacks::EventMocker
  def mock_stripe_event(name, args = nil)
    StripeModelCallbacks::EventMockerService.new(name: name, scope: self, args: args)
  end
end

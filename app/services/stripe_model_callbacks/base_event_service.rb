class StripeModelCallbacks::BaseEventService < ServicePattern::Service
  attr_reader :event

  def initialize(event:)
    @event = event
  end

  def object
    event.data.object
  end
end

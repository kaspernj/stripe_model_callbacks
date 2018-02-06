class StripeModelCallbacks::BaseEventService < ServicePattern::Service
  attr_reader :event, :object

  def initialize(event: nil, object: nil)
    @event = event
    @object = object
    @object ||= event.data.object
  end
end

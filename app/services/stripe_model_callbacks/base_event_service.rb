class StripeModelCallbacks::BaseEventService < StripeModelCallbacks::BaseService
  attr_reader :event, :object

  def initialize(event: nil, object: nil)
    @event = event
    @object = object
    @object ||= event.data.object
  end
end

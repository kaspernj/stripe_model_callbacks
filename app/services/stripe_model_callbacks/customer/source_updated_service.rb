class StripeModelCallbacks::Customer::SourceUpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    source = StripeSource.find_or_initialize_by(id: object.id)
    source.assign_from_stripe(object)

    if source.save
      source.create_activity :deleted if event.type == "customer.source.deleted"
      source.create_activity :expiring if event.type == "customer.source.expiring"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: source.errors.full_messages)
    end
  end
end

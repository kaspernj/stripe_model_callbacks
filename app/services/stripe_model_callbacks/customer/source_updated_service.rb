class StripeModelCallbacks::Customer::SourceUpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    source = StripeSource.find_or_initialize_by(identifier: object.id)
    source.assign_from_stripe(object)

    if source.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: source.errors.full_messages)
    end
  end
end

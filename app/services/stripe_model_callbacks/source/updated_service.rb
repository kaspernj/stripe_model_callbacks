class StripeModelCallbacks::Source::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    source.assign_from_stripe(object)

    if source.save
      create_activity
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: source.errors.full_messages)
    end
  end

private

  def create_activity
    case event.type
    when "source.canceled"
      source.create_activity :canceled
    when "source.chargeable"
      source.create_activity :chargeable
    when "source.failed"
      source.create_activity :failed
    when "source.mandate_notification"
      source.create_activity :mandate_notification
    end
  end

  def source
    @_source ||= StripeSource.find_or_initialize_by(stripe_id: object.id)
  end
end

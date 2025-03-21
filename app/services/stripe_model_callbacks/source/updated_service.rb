class StripeModelCallbacks::Source::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    source.assign_from_stripe(object)

    if source.save
      create_activity
      succeed!
    else
      fail! source.errors.full_messages
    end
  end

private

  def create_activity
    case event.type
    when "source.canceled"
      source.create_audit!(action: :canceled)
    when "source.chargeable"
      source.create_audit!(action: :chargeable)
    when "source.failed"
      source.create_audit!(action: :failed)
    when "source.mandate_notification"
      source.create_audit!(action: :mandate_notification)
    end
  end

  def source
    @source ||= StripeSource.find_or_initialize_by(stripe_id: object.id)
  end
end

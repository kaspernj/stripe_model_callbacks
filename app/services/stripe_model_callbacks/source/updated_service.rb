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
      source.try(:create_activity, :canceled)
    when "source.chargeable"
      source.try(:create_activity, :chargeable)
    when "source.failed"
      source.try(:create_activity, :failed)
    when "source.mandate_notification"
      source.try(:create_activity, :mandate_notification)
    end
  end

  def source
    @source ||= StripeSource.find_or_initialize_by(stripe_id: object.id)
  end
end

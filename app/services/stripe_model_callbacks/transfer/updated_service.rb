class StripeModelCallbacks::Transfer::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    transfer.assign_from_stripe(object)

    if transfer.save
      transfer.create_audit!(action: :reversed) if event.type == "transfer.reversed"
      succeed!
    else
      fail! transfer.errors.full_messages
    end
  end

private

  def transfer
    @transfer ||= StripeTransfer.find_or_initialize_by(stripe_id: object.id)
  end
end

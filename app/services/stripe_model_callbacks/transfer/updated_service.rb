class StripeModelCallbacks::Transfer::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    transfer.assign_from_stripe(object)

    if transfer.save
      transfer.create_activity :reversed if event.type == "transfer.reversed"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: transfer.errors.full_messages)
    end
  end

private

  def transfer
    @_transfer ||= StripeTransfer.find_or_initialize_by(stripe_id: object.id)
  end
end

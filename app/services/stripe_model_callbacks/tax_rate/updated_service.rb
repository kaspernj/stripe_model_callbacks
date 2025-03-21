class StripeModelCallbacks::TaxRate::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    tax_rate.assign_from_stripe(object)

    if tax_rate.save
      create_activity if event
      succeed! tax_rate
    else
      fail! tax_rate.errors.full_messages
    end
  end

private

  def create_activity
    case event.type
    when "tax_rate.created"
      tax_rate.create_audit!(action: :created)
    when "tax_rate.updated"
      tax_rate.create_audit!(action: :updated)
    end
  end

  def tax_rate
    @tax_rate ||= StripeTaxRate.find_or_initialize_by(stripe_id: object.is_a?(String) ? object : object.id)
  end
end

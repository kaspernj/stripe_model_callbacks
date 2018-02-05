class StripeModelCallbacks::Sku::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    sku = StripeModelCallbacks::StripeSku.find_or_initialize_by(identifier: object.id)
    sku.assign_from_stripe(object)
    sku.deleted_at ||= Time.zone.now if event.type == "sku.deleted"

    if sku.save
      sku.create_activity :deleted if event.type == "sku.deleted"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: sku.errors.full_messages)
    end
  end
end

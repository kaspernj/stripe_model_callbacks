class StripeModelCallbacks::Product::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    product = StripeModelCallbacks::StripeProduct.find_or_initialize_by(identifier: object.id)
    product.assign_from_stripe(object)
    product.deleted_at ||= Time.zone.now if event.type == "product.deleted"

    if product.save
      product.create_activity :deleted if event.type == "product.deleted"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: product.errors.full_messages)
    end
  end
end

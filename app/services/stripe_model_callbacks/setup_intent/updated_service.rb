class StripeModelCallbacks::SetupIntent::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    refund = StripeSetupIntent.find_or_initialize_by(stripe_id: object.id)
    refund.assign_from_stripe(object)
    save_models_or_fail(refund)
    succeed!
  end
end

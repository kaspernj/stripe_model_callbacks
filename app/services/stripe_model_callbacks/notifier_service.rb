class StripeModelCallbacks::NotifierService < StripeModelCallbacks::BaseEventService
  def perform
    Rails.logger.info "New Stripe event: #{event.type}"
    succeed!
  end
end

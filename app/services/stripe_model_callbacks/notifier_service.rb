class StripeModelCallbacks::NotifierService < StripeModelCallbacks::BaseEventService
  def execute
    Rails.logger.info "New Stripe event: #{event.type}"
    succeed!
  end
end

class StripeModelCallbacks::NotifierService < StripeModelCallbacks::BaseEventService
  def execute!
    Rails.logger.info "New Stripe event: #{event.type}"
    ServicePattern::Response.new(success: true)
  end
end

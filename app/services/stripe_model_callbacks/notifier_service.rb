class StripeModelCallbacks::NotifierService < StripeModelCallbacks::BaseEventService
  def execute!
    puts "NEW EVENT: #{event.type}"

    ServicePattern::Response.new(success: true)
  end
end

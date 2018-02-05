class StripeModelCallbacks::ConfigureService < StripeModelCallbacks::BaseEventService
  attr_reader :events

  def initialize(events:)
    @events = events
  end

  def execute!
    events.all do |event|
      StripeModelCallbacks::NotifierService.reported_execute!(event: event)
    end

    events.subscribe "customer.created" do |event|
      StripeModelCallbacks::Customer::CreatedService.reported_execute!(event: event)
    end

    events.subscribe "customer.deleted" do |event|
      StripeModelCallbacks::Customer::DeletedService.reported_execute!(event: event)
    end

    events.subscribe "customer.updated" do |event|
      StripeModelCallbacks::Customer::UpdatedService.reported_execute!(event: event)
    end

    # Will fire when source is changed (not on creation).
    # This also happens automatically:
    # https://stripe.com/blog/smarter-saved-cards
    events.subscribe "customer.source.updated" do |event|
      # event.data.object is a Stripe::Card object
      # {
      #    "id": "card_16v1zfEbFETX486M0RACAP7e",
      #    "object": "card",
      #    "address_city": null,
      #    "address_country": null,
      #    "address_line1": null,
      #    "address_line1_check": null,
      #    "address_line2": null,
      #    "address_state": null,
      #    "address_zip": null,
      #    "address_zip_check": null,
      #    "brand": "MasterCard",
      #    "country": "GB",
      #    "customer": "cus_79Kdwt3kkfIQRP",
      #    "cvc_check": "pass",
      #    "dynamic_last4": null,
      #    "exp_month": 3,
      #    "exp_year": 2016,
      #    "fingerprint": "QTtGDQKG32C06Rda",
      #    "funding": "credit",
      #    "last4": "5422",
      #    "metadata": {},
      #    "name": null,
      #    "tokenization_method": null
      # }
      StripeModelCallbacks::Customer::SourceUpdatedService.reported_execute!(event: event)
    end

    events.subscribe "invoice.payment_succeeded" do |event|
      StripeModelCallbacks::Invoice::PaymentSucceededService.reported_execute!(event: event)
    end

    events.subscribe "invoice.payment_failed" do |event|
      StripeModelCallbacks::Invoice::PaymentFailedService.reported_execute!(event: event)
    end

    events.subscribe "invoiceitem.created" do |event|
      StripeModelCallbacks::InvoiceItem::CreatedService.reported_execute!(event: event)
    end

    events.subscribe "charge.captured" do |event|
      StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "charge.failed" do |event|
      StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "charge.pending" do |event|
      StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "charge.refunded" do |event|
      StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "charge.updated" do |event|
      StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "charge.succeeded" do |event|
      StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "customer.subscription.created" do |event|
      StripeModelCallbacks::Customer::Subscription::CreatedService.reported_execute!(event: event)
    end

    # Eg when a subscription is renewed.
    events.subscribe "customer.subscription.updated" do |event|
      StripeModelCallbacks::Customer::Subscription::UpdatedService.reported_execute!(event: event)
    end

    # When a subscriptions is finally canceled.
    events.subscribe "customer.subscription.deleted" do |event|
      StripeModelCallbacks::Customer::Subscription::DeletedService.reported_execute!(event: event)
    end

    events.subscribe "order.created" do |event|
      StripeModelCallbacks::Order::UpdatedService.reported_execute!(event: event)
    end

    events.subscribe "order.updated" do |event|
      StripeModelCallbacks::Order::UpdatedService.reported_execute!(event: event)
    end
  end
end

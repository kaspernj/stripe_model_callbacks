class StripeModelCallbacks::ConfigureService < StripeModelCallbacks::BaseEventService
  attr_reader :events

  def initialize(events:)
    @events = events
  end

  def perform # rubocop:disable Metrics/AbcSize
    all_events
    charge_refund_events
    customer_bank_account_events
    account_external_account_events
    charge_events
    charge_dispute_events
    coupon_events
    customer_discount_events
    customer_events
    customer_source_events
    invoice_item_events
    invoice_events
    order_events
    recipient_events
    payment_intent_events
    payment_method_events
    payout_events
    plan_events
    price_events
    product_events
    refund_events
    review_events
    setup_intent_events
    sku_events
    source_events
    subscription_events
    subscription_schedule_events
    tax_rate_events
    transfer_events

    succeed!
  end

private

  def account_external_account_events
    %w[created deleted updated].each do |external_account_event|
      subscribe "account.external_account.#{external_account_event}" do |event|
        StripeModelCallbacks::Account::ExternalAccount::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def all_events
    events.all do |event|
      StripeModelCallbacks::NotifierService.execute_with_advisory_lock!(event:)
    end
  end

  def charge_events
    %w[captured failed pending refunded updated succeeded].each do |charge_event|
      subscribe "charge.#{charge_event}" do |event|
        StripeModelCallbacks::Charge::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def charge_refund_events
    subscribe "charge.refund.updated" do |event|
      StripeModelCallbacks::Refund::UpdatedService.execute_with_advisory_lock!(event:)
    end
  end

  def charge_dispute_events
    %w[closed created funds_reinstated funds_withdrawn updated].each do |charge_event|
      subscribe "charge.dispute.#{charge_event}" do |event|
        StripeModelCallbacks::Charge::DisputeUpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def coupon_events
    %w[created deleted updated].each do |coupon_event|
      subscribe "coupon.#{coupon_event}" do |event|
        StripeModelCallbacks::Coupon::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def customer_bank_account_events
    subscribe "customer.bank_account.deleted" do |event|
      StripeModelCallbacks::Customer::BankAccount::DeletedService.execute_with_advisory_lock!(event:)
    end
  end

  def customer_discount_events
    %w[created deleted updated].each do |customer_event|
      subscribe "customer.discount.#{customer_event}" do |event|
        StripeModelCallbacks::Customer::DiscountUpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def customer_events
    %w[created deleted updated].each do |customer_event|
      subscribe "customer.#{customer_event}" do |event|
        StripeModelCallbacks::Customer::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def customer_source_events
    %w[created deleted expiring updated].each do |customer_event|
      subscribe "customer.source.#{customer_event}" do |event|
        StripeModelCallbacks::Customer::SourceUpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def invoice_events
    # Upcoming event doesnt send an invoice ID. Dunno what to do about it... Disabling for now
    # upcoming

    # https://stripe.com/docs/billing/invoices/overview#invoice-status-transition-endpoints-and-webhooks
    %w[created deleted marked_uncollectible payment_failed payment_succeeded sent updated voided].each do |invoice_event|
      subscribe "invoice.#{invoice_event}" do |event|
        StripeModelCallbacks::Invoice::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def invoice_item_events
    %w[created deleted updated].each do |event_type|
      subscribe "invoiceitem.#{event_type}" do |event|
        StripeModelCallbacks::InvoiceItem::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def order_events
    %w[created updated].each do |order_event|
      subscribe "order.#{order_event}" do |event|
        StripeModelCallbacks::Order::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def payout_events
    %w[canceled created failed paid updated].each do |payout_event|
      subscribe "payout.#{payout_event}" do |event|
        StripeModelCallbacks::Payout::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def recipient_events
    %w[created deleted updated].each do |recipient_event|
      subscribe "recipient.#{recipient_event}" do |event|
        StripeModelCallbacks::Recipient::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def refund_events
    %w[created updated].each do |refund_event|
      subscribe "refund.#{refund_event}" do |event|
        StripeModelCallbacks::Refund::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def payment_intent_events
    %w[amount_capturable_updated canceled created partially_funded payment_failed processing requires_action succeeded].each do |plan_event|
      subscribe "payment_intent.#{plan_event}" do |event|
        StripeModelCallbacks::PaymentIntent::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def payment_method_events
    %w[attached automatically_updated card_automatically_updated detached updated].each do |plan_event|
      subscribe "payment_method.#{plan_event}" do |event|
        StripeModelCallbacks::PaymentMethod::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def plan_events
    %w[created deleted updated].each do |plan_event|
      subscribe "plan.#{plan_event}" do |event|
        StripeModelCallbacks::Plan::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def sku_events
    %w[created deleted updated].each do |sku_event|
      subscribe "sku.#{sku_event}" do |event|
        StripeModelCallbacks::Sku::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def price_events
    %w[created deleted updated].each do |price_event|
      subscribe "price.#{price_event}" do |event|
        StripeModelCallbacks::Price::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def product_events
    %w[created deleted updated].each do |product_event|
      subscribe "product.#{product_event}" do |event|
        StripeModelCallbacks::Product::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def review_events
    %w[opened closed].each do |review_event|
      subscribe "review.#{review_event}" do |event|
        StripeModelCallbacks::Review::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def setup_intent_events
    %w[created updated].each do |product_event|
      subscribe "setup_intent.#{product_event}" do |event|
        StripeModelCallbacks::SetupIntent::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def source_events
    %w[canceled chargeable failed mandate_notification].each do |source_event|
      subscribe "source.#{source_event}" do |event|
        StripeModelCallbacks::Source::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end

    subscribe "source.transaction.created" do |event|
      StripeModelCallbacks::Source::TransactionCreatedService.execute_with_advisory_lock!(event:)
    end
  end

  def subscribe(event_name)
    events.subscribe(event_name) do |event|
      StripeModelCallbacks::Configuration.current.with_error_handling(args: {event:}) do
        yield event
      end
    end
  end

  def subscription_events
    %w[created deleted trial_will_end updated].each do |subscription_event|
      subscribe "customer.subscription.#{subscription_event}" do |event|
        StripeModelCallbacks::Customer::Subscription::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def subscription_schedule_events
    %w[canceled created updated].each do |subscription_event|
      subscribe "subscription_schedule.#{subscription_event}" do |event|
        StripeModelCallbacks::SubscriptionSchedule::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def tax_rate_events
    %w[created updated].each do |transfer_event|
      subscribe "tax_rate.#{transfer_event}" do |event|
        StripeModelCallbacks::TaxRate::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end

  def transfer_events
    %w[created reversed updated].each do |transfer_event|
      subscribe "transfer.#{transfer_event}" do |event|
        StripeModelCallbacks::Transfer::UpdatedService.execute_with_advisory_lock!(event:)
      end
    end
  end
end

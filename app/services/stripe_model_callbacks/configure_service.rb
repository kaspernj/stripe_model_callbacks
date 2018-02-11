class StripeModelCallbacks::ConfigureService < StripeModelCallbacks::BaseEventService
  attr_reader :events

  def initialize(events:)
    @events = events
  end

  def execute!
    # events.subscribe "source.transaction.created"

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
    payout_events
    plan_events
    product_events
    review_events
    sku_events
    source_events
    subscription_events
    transfer_events
  end

private

  def account_external_account_events
    %w[created deleted updated].each do |external_account_event|
      events.subscribe "account.external_account.#{external_account_event}" do |event|
        StripeModelCallbacks::Account::ExternalAccount::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def all_events
    events.all do |event|
      StripeModelCallbacks::NotifierService.reported_execute!(event: event)
    end
  end

  def charge_events
    %w[captured failed pending refunded updated succeeded].each do |charge_event|
      events.subscribe "charge.#{charge_event}" do |event|
        StripeModelCallbacks::Charge::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def charge_refund_events
    events.subscribe "charge.refund.updated" do |event|
      StripeModelCallbacks::Refund::UpdatedService.reported_execute!(event: event)
    end
  end

  def charge_dispute_events
    %w[closed created funds_reinstated funds_withdrawn updated].each do |charge_event|
      events.subscribe "charge.dispute.#{charge_event}" do |event|
        StripeModelCallbacks::Charge::DisputeUpdatedService.reported_execute!(event: event)
      end
    end
  end

  def coupon_events
    %w[created deleted updated].each do |coupon_event|
      events.subscribe "coupon.#{coupon_event}" do |event|
        StripeModelCallbacks::Coupon::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def customer_bank_account_events
    events.subscribe "customer.bank_account.deleted" do |event|
      StripeModelCallbacks::Customer::BankAccount::DeletedService.reported_execute!(event: event)
    end
  end

  def customer_discount_events
    %w[created deleted updated].each do |customer_event|
      events.subscribe "customer.discount.#{customer_event}" do |event|
        StripeModelCallbacks::Customer::DiscountUpdatedService.reported_execute!(event: event)
      end
    end
  end

  def customer_events
    %w[created deleted updated].each do |customer_event|
      events.subscribe "customer.#{customer_event}" do |event|
        StripeModelCallbacks::Customer::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def customer_source_events
    %w[created deleted expiring updated].each do |customer_event|
      events.subscribe "customer.source.#{customer_event}" do |event|
        StripeModelCallbacks::Customer::SourceUpdatedService.reported_execute!(event: event)
      end
    end
  end

  def invoice_events
    # Upcoming event doesnt send an invoice ID. Dunno what to do about it... Disabling for now
    # upcoming

    %w[created payment_failed payment_succeeded sent updated].each do |invoice_event|
      events.subscribe "invoice.#{invoice_event}" do |event|
        StripeModelCallbacks::Invoice::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def invoice_item_events
    %w[created deleted updated].each do |event_type|
      events.subscribe "invoiceitem.#{event_type}" do |event|
        StripeModelCallbacks::InvoiceItem::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def order_events
    %w[created updated].each do |order_event|
      events.subscribe "order.#{order_event}" do |event|
        StripeModelCallbacks::Order::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def payout_events
    %w[canceled created failed paid updated].each do |payout_event|
      events.subscribe "payout.#{payout_event}" do |event|
        StripeModelCallbacks::Payout::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def recipient_events
    %w[created deleted updated].each do |recipient_event|
      events.subscribe "recipient.#{recipient_event}" do |event|
        StripeModelCallbacks::Recipient::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def plan_events
    %w[created deleted updated].each do |plan_event|
      events.subscribe "plan.#{plan_event}" do |event|
        StripeModelCallbacks::Plan::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def sku_events
    %w[created deleted updated].each do |sku_event|
      events.subscribe "sku.#{sku_event}" do |event|
        StripeModelCallbacks::Sku::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def product_events
    %w[created deleted updated].each do |product_event|
      events.subscribe "product.#{product_event}" do |event|
        StripeModelCallbacks::Product::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def review_events
    %w[opened closed].each do |review_event|
      events.subscribe "review.#{review_event}" do |event|
        StripeModelCallbacks::Review::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def source_events
    %w[canceled chargeable failed mandate_notification].each do |source_event|
      events.subscribe "source.#{source_event}" do |event|
        StripeModelCallbacks::Source::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def subscription_events
    %w[created deleted trial_will_end updated].each do |subscription_event|
      events.subscribe "customer.subscription.#{subscription_event}" do |event|
        StripeModelCallbacks::Customer::Subscription::UpdatedService.reported_execute!(event: event)
      end
    end
  end

  def transfer_events
    %w[created reversed updated].each do |transfer_event|
      events.subscribe "transfer.#{transfer_event}" do |event|
        StripeModelCallbacks::Transfer::UpdatedService.reported_execute!(event: event)
      end
    end
  end
end

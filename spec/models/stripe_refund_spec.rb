require "rails_helper"

describe StripeRefund do
  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 1984) }
  let(:charge) { Stripe::Charge.create(amount: 100_00, capture: false, currency: "dkk", customer: customer.id) }
  let(:customer) { Stripe::Customer.create(source: card_token) }
  let(:stripe_charge) { StripeCharge.create_from_stripe!(charge) }
  let(:stripe_customer) { StripeCustomer.create_from_stripe!(customer) }

  it "creates a new refund from a charge", :stripe_mock do
    stripe_refund = StripeRefund.create_on_stripe!(charge: stripe_charge.stripe_id)

    expect(stripe_refund).to have_attributes(
      amount: Money.new(100_00, "USD"),
      currency: "usd",
      reason: "requested_by_customer",
      status: "succeeded",
      stripe_charge_id: charge.id
    )
  end
end

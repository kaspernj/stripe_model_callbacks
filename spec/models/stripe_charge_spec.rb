require "rails_helper"

describe StripeCharge do
  let(:card_token) { StripeMock.generate_card_token(last4: "9191", exp_year: 1984) }
  let(:charge) { Stripe::Charge.create(amount: 100, capture: false, currency: "dkk", customer: customer.id) }
  let(:customer) { Stripe::Customer.create(source: card_token) }
  let(:stripe_charge) { StripeCharge.create_from_stripe!(charge) }
  let(:stripe_customer) { StripeCustomer.create_from_stripe!(customer) }

  describe "#capture" do
    it "captures the charge and updates the data model", :stripe_mock do
      expect(stripe_charge).to have_attributes(captured: false)
      stripe_charge.capture
      expect(stripe_charge).to have_attributes(captured: true)
    end
  end

  describe "#refund" do
    it "refunds the charge", :stripe_mock do
      expect { stripe_charge.refund }
        .to change(StripeRefund, :count).by(1)

      created_stripe_refund = StripeRefund.last!

      expect(created_stripe_refund).to have_attributes(
        amount_cents: 100,
        currency: "dkk",
        stripe_charge: stripe_charge
      )
    end
  end

  describe "#stripe_payment_intent" do
    it "resolves the relationship" do
      stripe_payment_intent = create :stripe_payment_intent
      stripe_charge = create :stripe_charge, payment_intent: stripe_payment_intent.stripe_id

      expect(stripe_charge).to have_attributes(stripe_payment_intent: stripe_payment_intent)
      expect(stripe_payment_intent).to have_attributes(stripe_charges: [stripe_charge])
    end
  end
end

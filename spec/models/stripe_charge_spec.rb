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
end

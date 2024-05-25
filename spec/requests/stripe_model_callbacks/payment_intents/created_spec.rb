require "rails_helper"

describe "payment intents - created" do
  let(:charge) { create :stripe_charge }
  let(:customer) { create :stripe_customer, stripe_id: "cus_NiCY7UI5u0pbJH" }
  let(:payment_method) { create :stripe_payment_method }

  describe "#execute!" do
    it "creates the payment intent and logs it" do
      data = {object: {customer: customer.stripe_id, latest_charge: charge.stripe_id, payment_method: payment_method.stripe_id}}

      expect { mock_stripe_event("payment_intent.created", data: data) }
        .to change(StripePaymentIntent, :count).by(1)
        .and change(Activity.where(key: "stripe_payment_intent.created"), :count).by(1)

      created_payment_intent = StripePaymentIntent.last!

      expect(response).to have_http_status :ok
      expect(created_payment_intent).to have_attributes(
        created: 1_627_149_796,
        customer: "cus_NiCY7UI5u0pbJH",
        latest_charge: charge.stripe_id,
        payment_method: payment_method.stripe_id,
        status: "requires_payment_method",
        stripe_customer: customer,
        stripe_latest_charge: charge,
        stripe_payment_method: payment_method
      )
      expect(charge).to have_attributes(
        latest_charge_on_stripe_payment_intent: created_payment_intent
      )
      expect(payment_method).to have_attributes(
        stripe_payment_intents: [created_payment_intent]
      )
    end
  end
end

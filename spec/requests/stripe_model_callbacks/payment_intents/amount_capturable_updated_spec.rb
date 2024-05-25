require "rails_helper"

describe "payment intents - amount capturable updated" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_NiCY7UI5u0pbJH" }
  let!(:payment_intent) { create :stripe_payment_intent, stripe_id: "pi_1JGpBw4Lf1hyuG3tSrdK3llw" }

  describe "#execute!" do
    it "updates the payment intent and logs it" do
      expect { mock_stripe_event("payment_intent.amount_capturable_updated") }
        .to change(StripePaymentIntent, :count).by(0)
        .and change(Activity.where(key: "stripe_payment_intent.amount_capturable_updated"), :count).by(1)

      expect(response).to have_http_status :ok
      expect(payment_intent.reload).to have_attributes(
        created: 1_627_149_796,
        status: "requires_payment_method",
        stripe_customer: customer
      )
    end
  end
end

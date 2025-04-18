require "rails_helper"

describe "payment intents - processing" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_NiCY7UI5u0pbJH" }
  let!(:payment_intent) { create :stripe_payment_intent, stripe_id: "pi_1JGpBw4Lf1hyuG3tSrdK3llw" }

  describe "#execute!" do
    it "updates the payment intent and logs it" do
      expect { mock_stripe_event("payment_intent.processing") }
        .to change(StripePaymentIntent, :count).by(0)
        .and change(ActiveRecordAuditable::Audit.where_type("StripePaymentIntent").where_action("processing"), :count).by(1)

      expect(response).to have_http_status :ok
      expect(payment_intent.reload).to have_attributes(
        created: 1_627_149_796,
        status: "requires_payment_method"
      )
    end
  end
end

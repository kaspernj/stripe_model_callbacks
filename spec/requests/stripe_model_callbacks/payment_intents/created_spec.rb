require "rails_helper"

describe "payment intents - created" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_NiCY7UI5u0pbJH" }

  describe "#execute!" do
    it "creates the payment intent and logs it" do
      expect { PublicActivity.with_tracking { mock_stripe_event("payment_intent.created") } }
        .to change(StripePaymentIntent, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_payment_intent.created"), :count).by(1)

      created_payment_intent = StripePaymentIntent.last!

      expect(response).to have_http_status :ok
      expect(created_payment_intent).to have_attributes(
        created: 1_627_149_796,
        status: "requires_payment_method"
      )
    end
  end
end

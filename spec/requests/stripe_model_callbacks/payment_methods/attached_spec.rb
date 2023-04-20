require "rails_helper"

describe "payment method updated" do
  let!(:payment_method) { create :stripe_payment_method, stripe_id: "prod_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("product.attached") } }
        .to change(StripePaymentMethod, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_payment_method.attached"), :count).by(1)

      expect(response.code).to eq "200"

      expect(payment_method.reload).to have_attributes(
        stripe_id: "prod_00000000000000",
        active: false,
        created: Time.zone.parse("2018-02-04 16:49:05"),
        updated: Time.zone.parse("2018-02-04 16:49:05"),
        name: "Extra Large",
        product_type: "service"
      )
    end
  end
end

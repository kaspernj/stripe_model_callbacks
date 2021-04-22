require "rails_helper"

describe "price deleted" do
  let!(:price) { create :stripe_price, stripe_id: "price_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("price.deleted") } }
        .to change(StripePrice, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_price.deleted"), :count).by(1)

      price.reload

      expect(response.code).to eq "200"

      expect(price).to have_attributes(
        stripe_id: "price_00000000000000",
        active: true,
        billing_scheme: "per_unit",
        created: Time.zone.parse("2020-12-24 12:47:55"),
        currency: "dkk",
        lookup_key: nil,
        metadata: "{}",
        nickname: nil,
        stripe_product_id: "prod_00000000000000",
        recurring_aggregate_usage: nil,
        recurring_interval: "month",
        recurring_interval_count: 1,
        recurring_usage_type: "licensed",
        tiers_mode: nil,
        transform_quantity_divide_by: nil,
        transform_quantity_round: nil,
        unit_amount: 2000
      )
      expect(price.deleted_at).to be > 1.minute.ago
    end
  end
end

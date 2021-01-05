require "rails_helper"

describe "price updated" do
  let!(:price) { create :stripe_price, stripe_id: "price_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("price.updated") }
        .to change(StripePrice, :count).by(0)

      price.reload

      expect(response.code).to eq "200"

      expect(price).to have_attributes(
        stripe_id: "price_00000000000000",
        active: true,
        billing_scheme: "per_unit",
        created: Time.zone.parse("2020-12-24 12:48:07"),
        currency: "dkk",
        deleted_at: nil,
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
    end
  end
end

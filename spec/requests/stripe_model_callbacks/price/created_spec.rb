require "rails_helper"

describe "price created" do
  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("price.created") }
        .to change(StripePrice, :count).by(1)

      created_price = StripePrice.last!

      expect(response).to have_http_status :ok

      expect(created_price).to have_attributes(
        stripe_id: "price_00000000000000",
        active: true,
        billing_scheme: "per_unit",
        created: Time.zone.parse("2020-12-24 12:47:34"),
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

require "rails_helper"

describe "customer discount updated" do
  let!(:old_coupon) { create :stripe_coupon, id: "OLD_COUPON_ID" }
  let!(:coupon) { create :stripe_coupon, id: "25OFF_00000000000000" }
  let!(:customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:discount) { create :stripe_discount, stripe_coupon: old_coupon, stripe_customer: customer }

  describe "#execute!" do
    it "updates the existing discount" do
      expect { mock_stripe_event("customer.discount.updated") }
        .to change(StripeDiscount, :count).by(0)

      discount.reload

      expect(response.code).to eq "200"

      expect(discount.stripe_coupon_id).to eq "25OFF_00000000000000"
      expect(discount.stripe_coupon).to eq coupon
      expect(discount.stripe_customer_id).to eq "cus_00000000000000"
      expect(discount.stripe_customer).to eq customer
      expect(discount.coupon_amount_off).to eq nil
      expect(discount.coupon_created).to eq Time.zone.parse("2018-02-06 12:29:51")
      expect(discount.coupon_currency).to eq nil
      expect(discount.coupon_duration).to eq "repeating"
      expect(discount.coupon_duration_in_months).to eq 3
      expect(discount.coupon_livemode).to eq false
      expect(discount.coupon_max_redemptions).to eq nil
      expect(discount.coupon_metadata).to eq "{}"
      expect(discount.coupon_percent_off).to eq 25
      expect(discount.coupon_redeem_by).to eq nil
      expect(discount.coupon_times_redeemed).to eq 0
      expect(discount.coupon_valid).to eq true
      expect(discount.start).to eq Time.zone.parse("2018-02-06 12:29:51")
      expect(discount.end).to eq Time.zone.parse("2018-05-06 12:29:51")
      expect(discount.stripe_subscription_id).to eq nil
      expect(discount.stripe_subscription).to eq nil
    end
  end
end

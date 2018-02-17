require "rails_helper"

describe "customer discount creation" do
  let!(:coupon) { create :stripe_coupon, id: "25OFF_00000000000000" }
  let!(:customer) { create :stripe_customer, id: "cus_00000000000000" }

  describe "#execute!" do
    it "adds a new discount" do
      expect { mock_stripe_event("customer.discount.created") }
        .to change(StripeDiscount, :count).by(1)

      created_discount = StripeDiscount.last

      expect(response.code).to eq "200"

      expect(created_discount.stripe_coupon_id).to eq "25OFF_00000000000000"
      expect(created_discount.stripe_coupon).to eq coupon
      expect(created_discount.stripe_customer_id).to eq "cus_00000000000000"
      expect(created_discount.stripe_customer).to eq customer
      expect(created_discount.coupon_amount_off).to eq nil
      expect(created_discount.coupon_created).to eq Time.zone.parse("2018-02-06 12:29:34")
      expect(created_discount.coupon_currency).to eq nil
      expect(created_discount.coupon_duration).to eq "repeating"
      expect(created_discount.coupon_duration_in_months).to eq 3
      expect(created_discount.coupon_livemode).to eq false
      expect(created_discount.coupon_max_redemptions).to eq nil
      expect(created_discount.coupon_metadata).to eq "{}"
      expect(created_discount.coupon_percent_off).to eq 25
      expect(created_discount.coupon_redeem_by).to eq nil
      expect(created_discount.coupon_times_redeemed).to eq 0
      expect(created_discount.coupon_valid).to eq true
      expect(created_discount.start).to eq Time.zone.parse("2018-02-06 12:29:34")
      expect(created_discount.end).to eq Time.zone.parse("2018-05-06 12:29:34")
      expect(created_discount.stripe_subscription_id).to eq nil
      expect(created_discount.stripe_subscription).to eq nil
    end
  end
end

require "rails_helper"

describe "coupon created" do
  describe "#execute!" do
    it "creates the coupon" do
      expect { mock_stripe_event("coupon.created") }
        .to change(StripeCoupon, :count).by(1)

      created_coupon = StripeCoupon.last

      expect(response).to have_http_status :ok

      expect(created_coupon.stripe_id).to eq "25OFF_00000000000000"
      expect(created_coupon.amount_off).to be_nil
      expect(created_coupon.created).to eq Time.zone.parse("2018-02-06 09:27:55")
      expect(created_coupon.currency).to be_nil
      expect(created_coupon.duration).to eq "repeating"
      expect(created_coupon.duration_in_months).to eq 3
      expect(created_coupon.livemode).to be false
      expect(created_coupon.max_redemptions).to be_nil
      expect(created_coupon.metadata).to eq "{}"
      expect(created_coupon.percent_off).to eq 25
      expect(created_coupon.redeem_by).to be_nil
      expect(created_coupon.times_redeemed).to eq 0
      expect(created_coupon.stripe_valid).to be true
    end
  end
end

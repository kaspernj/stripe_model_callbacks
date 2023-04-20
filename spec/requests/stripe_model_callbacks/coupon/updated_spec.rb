require "rails_helper"

describe "coupon updated" do
  let!(:coupon) { create :stripe_coupon, stripe_id: "25OFF_00000000000000" }

  describe "#execute!" do
    it "updates the coupon" do
      expect { mock_stripe_event("coupon.updated") }
        .to change(StripeCoupon, :count).by(0)

      coupon.reload

      expect(response).to have_http_status :ok

      expect(coupon.stripe_id).to eq "25OFF_00000000000000"
      expect(coupon.amount_off).to be_nil
      expect(coupon.created).to eq Time.zone.parse("2018-02-06 09:28:29")
      expect(coupon.currency).to be_nil
      expect(coupon.duration).to eq "repeating"
      expect(coupon.duration_in_months).to eq 3
      expect(coupon.livemode).to be false
      expect(coupon.max_redemptions).to be_nil
      expect(coupon.metadata).to eq "{}"
      expect(coupon.percent_off).to eq 25
      expect(coupon.redeem_by).to be_nil
      expect(coupon.times_redeemed).to eq 0
      expect(coupon.stripe_valid).to be true
    end
  end
end

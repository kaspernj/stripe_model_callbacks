require "rails_helper"

describe "coupon deleted" do
  let!(:coupon) { create :stripe_coupon, stripe_id: "25OFF_00000000000000" }

  describe "#execute!" do
    it "marks the coupon as deleted" do
      expect { mock_stripe_event("coupon.deleted") }
        .to change(StripeCoupon, :count).by(0)

      coupon.reload

      expect(response.code).to eq "200"

      expect(coupon.stripe_id).to eq "25OFF_00000000000000"
      expect(coupon.amount_off).to eq nil
      expect(coupon.created).to eq Time.zone.parse("2018-02-06 09:28:16")
      expect(coupon.currency).to eq nil
      expect(coupon.duration).to eq "repeating"
      expect(coupon.duration_in_months).to eq 3
      expect(coupon.livemode).to eq false
      expect(coupon.max_redemptions).to eq nil
      expect(coupon.metadata).to eq "{}"
      expect(coupon.name).to eq "3 months - 25 percent off"
      expect(coupon.percent_off).to eq 25
      expect(coupon.redeem_by).to eq nil
      expect(coupon.times_redeemed).to eq 0
      expect(coupon.stripe_valid).to eq true
      expect(coupon.deleted_at).to be > 1.minute.ago
    end
  end
end

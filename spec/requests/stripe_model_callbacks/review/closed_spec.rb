require "rails_helper"

describe "review closed" do
  let!(:review) { create :stripe_review, id: "prv_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("review.closed") } }
        .to change(StripeReview, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_review.closed"), :count).by(1)

      review.reload

      expect(response.code).to eq "200"

      expect(review.id).to eq "prv_00000000000000"
      expect(review.stripe_charge_id).to eq "ch_00000000000000"
      expect(review.created).to eq Time.zone.parse("2018-02-08 12:07:22")
      expect(review.livemode).to eq false
      expect(review.open).to eq true
      expect(review.reason).to eq "rule"
    end
  end
end

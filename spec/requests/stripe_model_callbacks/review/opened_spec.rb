require "rails_helper"

describe "review opened" do
  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("review.opened") }
        .to change(StripeReview, :count).by(1)
        .and change(Activity.where(key: "stripe_review.create"), :count).by(1)

      created_review = StripeReview.last

      expect(response).to have_http_status :ok

      expect(created_review.stripe_id).to eq "prv_00000000000000"
      expect(created_review.stripe_charge_id).to eq "ch_00000000000000"
      expect(created_review.created).to eq Time.zone.parse("2018-02-08 12:06:46")
      expect(created_review.livemode).to be false
      expect(created_review.open).to be true
      expect(created_review.reason).to eq "rule"
    end
  end
end

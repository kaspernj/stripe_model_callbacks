require "rails_helper"

describe "subscription deletion" do
  let!(:customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:plan) { create :stripe_plan, id: "silver-express-898_00000000000000" }
  let!(:subscription) { create :stripe_subscription, stripe_customer: customer, stripe_plan: plan, id: "sub_00000000000000" }

  describe "#execute!" do
    it "ends the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("customer.subscription.deleted") } }
        .to change(PublicActivity::Activity.where(key: "stripe_subscription.deleted"), :count).by(1)

      subscription.reload

      expect(response.code).to eq "200"
      expect(subscription.stripe_customer).to eq customer
      expect(subscription.stripe_plan).to eq plan
      expect(subscription.ended_at).to eq Time.zone.at(1_517_769_949)
    end
  end
end

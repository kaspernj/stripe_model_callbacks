require "rails_helper"

describe "subscription deletion" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let!(:plan) { create :stripe_plan, stripe_id: "silver-express-898" }
  let!(:subscription) { create :stripe_subscription, stripe_customer: customer, stripe_plan: plan, stripe_id: "sub_00000000000000" }

  describe "#execute!" do
    it "ends the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("customer.subscription.deleted") } }
        .to change(PublicActivity::Activity.where(key: "stripe_subscription.deleted"), :count).by(1)
        .and change(StripeSubscriptionItem, :count).by(1)

      subscription.reload

      expect(response.code).to eq "200"
      expect(subscription).to have_attributes(
        stripe_customer: customer,
        stripe_plan: plan,
        stripe_plans: [plan],
        ended_at: Time.zone.at(1_517_769_949)
      )
    end
  end
end

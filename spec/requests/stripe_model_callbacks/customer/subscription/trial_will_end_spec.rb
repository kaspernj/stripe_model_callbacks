require "rails_helper"

describe "subscription trial will end" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let!(:plan) { create :stripe_plan, stripe_id: "silver-express-898_00000000000000" }
  let!(:subscription) { create :stripe_subscription, stripe_customer: customer, stripe_plan: plan, stripe_id: "sub_00000000000000" }

  describe "#execute!" do
    it "adds an activity and updates the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("customer.subscription.trial_will_end") } }
        .to change(StripeSubscription, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_subscription.trial_will_end"), :count).by(1)

      subscription.reload

      expect(response).to have_http_status :ok
      expect(subscription).to have_attributes(
        stripe_customer: customer,
        stripe_plan: plan,
        ended_at: nil,
        start_date: Time.zone.parse("2018-02-06 12:11:19"),
        status: "trialing",
        trial_start: Time.zone.parse("2018-02-06 11:45:51"),
        trial_end: Time.zone.parse("2018-02-09 11:45:51")
      )
    end
  end
end

require "rails_helper"

describe "subscription trial will end" do
  let!(:customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:plan) { create :stripe_plan, id: "silver-express-898_00000000000000" }
  let!(:subscription) { create :stripe_subscription, stripe_customer: customer, stripe_plan: plan, id: "sub_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.subscription.trial_will_end.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "adds and activity and updates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeSubscription, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_subscription.trial_will_end"), :count).by(1)

      subscription.reload

      expect(response.code).to eq "200"
      expect(subscription.stripe_customer).to eq customer
      expect(subscription.stripe_plan).to eq plan
      expect(subscription.ended_at).to eq nil
      expect(subscription.start).to eq Time.zone.parse("2018-02-06 12:11:19")
      expect(subscription.status).to eq "trialing"
      expect(subscription.trial_start).to eq Time.zone.parse("2018-02-06 11:45:51")
      expect(subscription.trial_end).to eq Time.zone.parse("2018-02-09 11:45:51")
    end
  end
end

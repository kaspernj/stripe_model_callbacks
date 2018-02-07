require "rails_helper"

describe "subscription updating" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:stripe_plan) { create :stripe_plan, id: "silver-express-898" }
  let!(:stripe_subscription) { create :stripe_subscription, id: "sub_CGPu5KqP1TORKF" }
  let!(:stripe_subscription_item) do
    create :stripe_subscription_item, stripe_plan: stripe_plan, stripe_subscription: stripe_subscription, id: "si_CGPuxYgJ7bx2UW"
  end

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.subscription.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeSubscription, :count).by(0)
        .and change(StripeSubscriptionItem, :count).by(0)

      stripe_subscription.reload
      stripe_subscription_item.reload

      expect(response.code).to eq "200"

      expect(stripe_subscription.stripe_customer).to eq stripe_customer
      expect(stripe_subscription.stripe_plan).to eq stripe_plan
      expect(stripe_subscription.current_period_end).to eq Time.zone.at(1_520_191_372)

      expect(stripe_subscription_item.stripe_subscription).to eq stripe_subscription
      expect(stripe_subscription_item.stripe_plan).to eq stripe_plan
    end
  end
end

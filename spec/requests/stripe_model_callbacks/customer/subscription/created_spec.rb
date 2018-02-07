require "rails_helper"

describe "subscription creation" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:stripe_plan) { create :stripe_plan, id: "silver-express-898" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.subscription.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeSubscription, :count).by(1)
        .and change(StripeSubscriptionItem, :count).by(1)

      created_subscription = StripeSubscription.last
      created_subscription_item = StripeSubscriptionItem.last

      expect(response.code).to eq "200"

      expect(created_subscription.stripe_customer).to eq stripe_customer
      expect(created_subscription.stripe_plan).to eq stripe_plan

      expect(created_subscription_item.id).to eq "si_CGPX2RZhm2pE0o"
      expect(created_subscription_item.stripe_subscription_id).to eq "sub_CGPXJjUMVXBLSx"
      expect(created_subscription_item.stripe_subscription).to eq created_subscription
      expect(created_subscription_item.stripe_plan_id).to eq "silver-express-898"
      expect(created_subscription_item.stripe_plan).to eq stripe_plan
    end
  end
end

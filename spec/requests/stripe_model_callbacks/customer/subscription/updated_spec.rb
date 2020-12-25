require "rails_helper"

describe "subscription updating" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let!(:stripe_plan) { create :stripe_plan, stripe_id: "silver-express-898" }
  let!(:stripe_subscription) { create :stripe_subscription, stripe_id: "sub_CGPu5KqP1TORKF" }
  let!(:stripe_subscription_item) do
    create :stripe_subscription_item, stripe_plan: stripe_plan, stripe_subscription: stripe_subscription, stripe_id: "si_CGPuxYgJ7bx2UW"
  end
  let(:stripe_subscription_default_tax_rate) do
    create :stripe_subscription_default_tax_rate,
      stripe_subscription: stripe_subscription,
      stripe_tax_rate: stripe_tax_rate
  end
  let(:stripe_tax_rate) { create :stripe_tax_rate }

  describe "#execute!" do
    it "updates the subscription" do
      expect { mock_stripe_event("customer.subscription.updated") }
        .to change(StripeSubscription, :count).by(0)
        .and change(StripeSubscriptionItem, :count).by(0)

      stripe_subscription.reload
      stripe_subscription_item.reload

      expect(response.code).to eq "200"

      expect(stripe_subscription).to have_attributes(
        stripe_customer: stripe_customer,
        stripe_plan: stripe_plan,
        stripe_plans: [stripe_plan],
        current_period_end: Time.zone.at(1_520_191_372)
      )
      expect(stripe_subscription_item).to have_attributes(
        stripe_subscription: stripe_subscription,
        stripe_plan: stripe_plan
      )
    end

    it "updates changes to default tax rates" do
      default_tax_rates = [
        {
          "id": "txr_1I1qD2AT5SYrvIfd69tAvJe2",
          "object": "tax_rate",
          "active": true,
          "created": 1_608_802_452,
          "description": nil,
          "display_name": "VAT DK",
          "inclusive": false,
          "jurisdiction": nil,
          "livemode": false,
          "metadata": {},
          "percentage": 25.0
        }
      ]

      expect { mock_stripe_event("customer.subscription.updated", data: {object: {default_tax_rates: default_tax_rates}}) }
        .to change(StripeSubscription, :count).by(0)
        .and change(StripeSubscriptionDefaultTaxRate, :count).by(1)
        .and change(StripeSubscriptionItem, :count).by(0)
        .and change(StripeTaxRate, :count).by(1)
    end
  end

  it "destroys default tax rates no longer found" do
    stripe_subscription
    stripe_subscription_default_tax_rate

    expect { mock_stripe_event("customer.subscription.created.2020-12-24", data: {object: {default_tax_rates: [], id: "sub_CGPu5KqP1TORKF"}}) }
      .to change(StripeSubscription, :count).by(0)
      .and change(StripeSubscriptionDefaultTaxRate, :count).by(-1)
      .and change(StripeTaxRate, :count).by(0)
  end
end

require "rails_helper"

describe StripeModelCallbacks::Plan::SyncAll, :stripe_mock do
  let(:stripe_product) { create :stripe_product }

  it "creates the model locally" do
    mock_plan = Stripe::Plan.create(amount: 1000, id: "test-plan", currency: "usd", name: "Test plan", interval: 1, product: stripe_product.stripe_id)

    expect { StripeModelCallbacks::Plan::SyncAll.execute! }
      .to change(StripePlan, :count).by(1)

    created_plan = StripePlan.last!

    expect(created_plan).to have_attributes(
      currency: "usd",
      interval: "1",
      stripe_id: "test-plan",
      stripe_product_id: stripe_product.stripe_id
    )
  end
end

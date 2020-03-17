require "rails_helper"

describe StripeModelCallbacks::SyncFromStripe, :stripe_mock do
  let(:stripe_product) { create :stripe_product, :with_stripe_mock }

  it "creates the model locally" do
    mock_plan = Stripe::Plan.create(amount: 1000, id: "test-plan", currency: "usd", name: "Test plan", interval: "month", product: stripe_product.stripe_id)

    expect { StripeModelCallbacks::SyncFromStripe.execute!(stripe_object: mock_plan) }
      .to change(StripePlan, :count).by(1)

    created_plan = StripePlan.last!

    expect(created_plan).to have_attributes(
      currency: "usd",
      interval: "month",
      stripe_id: "test-plan",
      stripe_product_id: stripe_product.stripe_id
    )
  end
end

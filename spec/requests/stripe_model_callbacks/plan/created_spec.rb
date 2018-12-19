require "rails_helper"

describe "plan updated" do
  let!(:stripe_product) { create :stripe_product, stripe_id: "prod_00000000000000", name: "Test product" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { mock_stripe_event("plan.created") }
        .to change(StripePlan, :count).by(1)

      plan = StripePlan.last

      expect(response.code).to eq "200"

      expect(plan.stripe_id).to eq "peak_00000000000000"
      expect(plan.amount.format).to eq "60.00 kr."
      expect(plan.created).to eq Time.zone.parse("2018-02-07 07:56:13")
      expect(plan.metadata).to eq "{}"
      expect(plan.interval).to eq "month"
      expect(plan.interval_count).to eq 1
      expect(plan.currency).to eq "dkk"
      expect(plan.name).to eq "Test product"
      expect(plan.nickname).to eq nil
      expect(plan.livemode).to eq false
      expect(plan.statement_descriptor).to eq nil
      expect(plan.trial_period_days).to eq nil
      expect(plan.stripe_product_id).to eq "prod_00000000000000"
      expect(plan.stripe_product).to eq stripe_product
    end
  end
end

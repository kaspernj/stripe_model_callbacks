require "rails_helper"

describe "plan updated" do
  let!(:stripe_product) { create :stripe_product, stripe_id: "prod_00000000000000", name: "Test product" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { mock_stripe_event("plan.created") }
        .to change(StripePlan, :count).by(1)

      plan = StripePlan.last

      expect(response).to have_http_status :ok

      expect(plan.stripe_id).to eq "peak_00000000000000"
      expect(plan.active).to be true
      expect(plan.aggregate_usage).to eq "sum"
      expect(plan.amount.format).to eq "60.00 kr."
      expect(plan.amount_decimal).to eq "6000"
      expect(plan.billing_scheme).to eq "per_unit"
      expect(plan.created).to eq Time.zone.parse("2018-02-07 07:56:13")
      expect(plan.metadata).to eq "{}"
      expect(plan.interval).to eq "month"
      expect(plan.interval_count).to eq 1
      expect(plan.currency).to eq "dkk"
      expect(plan.name).to eq "number of requests"
      expect(plan.nickname).to eq "number of requests"
      expect(plan.livemode).to be false
      expect(plan.statement_descriptor).to be_nil
      expect(plan.trial_period_days).to be_nil
      expect(plan.stripe_product_id).to eq "prod_00000000000000"
      expect(plan.stripe_product).to eq stripe_product
      expect(plan.usage_type).to eq "metered"
    end
  end
end

require "rails_helper"

describe "plan deleted" do
  let!(:plan) { create :stripe_plan, stripe_id: "peak_00000000000000", stripe_product: product }
  let!(:product) { create :stripe_product, stripe_id: "prod_00000000000000", name: "Test product" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { PublicActivity.with_tracking { mock_stripe_event("plan.deleted") } }
        .to change(StripePlan, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_plan.deleted"), :count).by(1)

      plan.reload

      expect(response).to have_http_status :ok

      expect(plan.stripe_id).to eq "peak_00000000000000"
      expect(plan.amount.format).to eq "60.00 kr."
      expect(plan.created).to eq Time.zone.parse("2018-02-07 07:56:13")
      expect(plan.metadata).to eq "{}"
      expect(plan.interval).to eq "month"
      expect(plan.interval_count).to eq 1
      expect(plan.currency).to eq "dkk"
      expect(plan.livemode).to be false
      expect(plan.name).to eq "Test product"
      expect(plan.nickname).to be_nil
      expect(plan.statement_descriptor).to be_nil
      expect(plan.trial_period_days).to be_nil
      expect(plan.deleted_at).to be > 1.minute.ago
    end
  end
end

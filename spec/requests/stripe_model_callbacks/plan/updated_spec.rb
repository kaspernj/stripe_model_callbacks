require "rails_helper"

describe "plan updated" do
  let!(:plan) { create :stripe_plan, id: "peak_00000000000000", stripe_product: product }
  let!(:product) { create :stripe_product, id: "prod_00000000000000", name: "Test product" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/plan/plan.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { post "/stripe-events", params: payload }
        .to change(StripePlan, :count).by(0)
        .and change(StripeProduct, :count).by(0)

      plan.reload

      expect(response.code).to eq "200"

      expect(plan.id).to eq "peak_00000000000000"
      expect(plan.amount.format).to eq "60.00 kr."
      expect(plan.created).to eq Time.zone.parse("2018-02-07 07:56:13")
      expect(plan.metadata).to eq "{}"
      expect(plan.interval).to eq "month"
      expect(plan.interval_count).to eq 1
      expect(plan.currency).to eq "dkk"
      expect(plan.livemode).to eq false
      expect(plan.name).to eq "Test product"
      expect(plan.nickname).to eq nil
      expect(plan.stripe_product_id).to eq "prod_00000000000000"
      expect(plan.stripe_product).to eq product
      expect(plan.statement_descriptor).to eq nil
      expect(plan.trial_period_days).to eq nil
    end
  end
end

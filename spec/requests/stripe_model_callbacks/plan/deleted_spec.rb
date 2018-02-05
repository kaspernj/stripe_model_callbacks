require "rails_helper"

describe "plan deleted" do
  let!(:plan) { create :stripe_plan, identifier: "gold_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/plan_deleted.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeModelCallbacks::StripePlan, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_model_callbacks_stripe_plan.deleted"), :count).by(1)

      plan.reload

      expect(response.code).to eq "200"

      expect(plan.identifier).to eq "gold_00000000000000"
      expect(plan.amount.format).to eq "$20.00"
      expect(plan.created_at).to eq Time.zone.parse("2018-02-05 15:52:34")
      expect(plan.metadata).to eq "{}"
      expect(plan.interval).to eq "month"
      expect(plan.interval_count).to eq 1
      expect(plan.currency).to eq "usd"
      expect(plan.livemode).to eq false
      expect(plan.name).to eq "Extra Large"
      expect(plan.statement_descriptor).to eq nil
      expect(plan.trial_period_days).to eq nil
      expect(plan.deleted_at).to be > 1.minute.ago
    end
  end
end

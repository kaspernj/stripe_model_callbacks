require "rails_helper"

describe "subscription_schedule created" do
  describe "#execute!" do
    subject(:stripe_event) { mock_stripe_event("subscription_schedule.created") }

    let(:stripe_id) { "sub_sched_1GhwDXJ3a8kmO8fm97mybWCy" }
    let(:stripe_subscription_schedule) { StripeSubscriptionSchedule.last }
    let(:stripe_subscription_schedule_phase) { stripe_subscription_schedule.stripe_subscription_schedule_phases.first }
    let(:stripe_subscription_schedule_phase_plan) { stripe_subscription_schedule_phase.stripe_subscription_schedule_phase_plans.first }

    it "responses with 200" do
      stripe_event

      expect(response).to have_http_status(:ok)
    end

    it "creates a subscription_schedule" do
      expect { stripe_event }
        .to change(StripeSubscriptionSchedule, :count).by(1)
    end

    it "saves data from stripe" do
      stripe_event

      expect(stripe_subscription_schedule).to have_attributes(
        stripe_id:,
        billing: "charge_automatically",
        billing_thresholds_amount_gte: nil,
        billing_thresholds_reset_billing_cycle_anchor: nil,
        canceled_at: nil,
        collection_method: "charge_automatically",
        completed_at: nil,
        created: Time.zone.parse("2020-05-12 11:24:11"),
        current_phase_end_date: nil,
        current_phase_start_date: nil,
        stripe_customer_id: "cus_HG9JJV3LEHUjhO",
        default_payment_method: nil,
        default_source: nil,
        end_behavior: "cancel",
        invoice_settings_days_until_due: nil,
        livemode: false,
        metadata: "{}",
        released_at: nil,
        released_stripe_subscription_id: nil,
        renewal_behavior: "cancel",
        renewal_interval: nil,
        status: "not_started",
        stripe_subscription_id: nil
      )
    end

    it "creates the subscription_schedule_phases" do
      expect { stripe_event }
        .to change(StripeSubscriptionSchedulePhase, :count).by(1)
    end

    it "saves subscription_schedule_phases data from stripe" do
      stripe_event

      expect(stripe_subscription_schedule_phase).to have_attributes(
        stripe_subscription_schedule_id: stripe_id,
        application_fee_percent: nil,
        billing_thresholds_amount_gte: nil,
        billing_thresholds_reset_billing_cycle_anchor: nil,
        collection_method: "charge_automatically",
        stripe_coupon_id: nil,
        default_payment_method: nil,
        end_date: Time.zone.parse("2020-12-01 00:00:00"),
        invoice_settings_days_until_due: nil,
        prorate: true,
        proration_behavior: "create_prorations",
        start_date: Time.zone.parse("2020-06-01 00:00:00"),
        trial_end: nil
      )
    end

    it "creates the subscription_schedule_phase_plan" do
      expect { stripe_event }
        .to change(StripeSubscriptionSchedulePhasePlan, :count).by(1)
    end

    it "saves subscription_schedule_phase_plan data from stripe" do
      stripe_event

      expect(stripe_subscription_schedule_phase_plan).to have_attributes(
        billing_thresholds_usage_gte: nil,
        stripe_plan_id: "plan_HG4dIu1k8KqRWi",
        stripe_price_id: "plan_HG4dIu1k8KqRWi",
        quantity: 2
      )
    end
  end
end

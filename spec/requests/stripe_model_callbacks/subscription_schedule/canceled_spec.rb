require "rails_helper"

describe "subscription_schedule created" do
  describe "#execute!" do
    subject(:stripe_subscription_schedule) { StripeSubscriptionSchedule.last }

    let(:stripe_event) { mock_stripe_event("subscription_schedule.canceled") }
    let(:stripe_subscription_schedule_phase_plan) { stripe_subscription_schedule_phase.stripe_subscription_schedule_phase_plans.first }
    let(:stripe_subscription_schedule_phase) { stripe_subscription_schedule.stripe_subscription_schedule_phases.first }

    it "creates the subscription_schedule", :aggregate_failures do
      expect { stripe_event }
        .to change(StripeSubscriptionSchedule, :count).by(1)

      expect(response.code).to eq "200"
      expect(stripe_subscription_schedule.stripe_id).to eq "sub_sched_1GhwDXJ3a8kmO8fmxeer3WCy"
      expect(stripe_subscription_schedule.billing).to eq "charge_automatically"
      expect(stripe_subscription_schedule.billing_thresholds_amount_gte).to eq nil
      expect(stripe_subscription_schedule.billing_thresholds_reset_billing_cycle_anchor).to eq nil
      expect(stripe_subscription_schedule.canceled_at).to eq Time.zone.parse("2020-05-12 13:13:31")
      expect(stripe_subscription_schedule.collection_method).to eq "charge_automatically"
      expect(stripe_subscription_schedule.completed_at).to eq nil
      expect(stripe_subscription_schedule.created).to eq Time.zone.parse("2020-05-12 11:24:11")
      expect(stripe_subscription_schedule.current_phase_end_date).to eq nil
      expect(stripe_subscription_schedule.current_phase_start_date).to eq nil
      expect(stripe_subscription_schedule.stripe_customer_id).to eq "cus_HG9JJV3LEHUjhO"
      expect(stripe_subscription_schedule.default_payment_method).to eq nil
      expect(stripe_subscription_schedule.default_source).to eq nil
      expect(stripe_subscription_schedule.end_behavior).to eq "cancel"
      expect(stripe_subscription_schedule.invoice_settings_days_until_due).to eq nil
      expect(stripe_subscription_schedule.livemode).to eq false
      expect(stripe_subscription_schedule.metadata).to eq "{}"
      expect(stripe_subscription_schedule.released_at).to eq nil
      expect(stripe_subscription_schedule.released_stripe_subscription_id).to eq nil
      expect(stripe_subscription_schedule.renewal_behavior).to eq "cancel"
      expect(stripe_subscription_schedule.renewal_interval).to eq nil
      expect(stripe_subscription_schedule.status).to eq "canceled"
      expect(stripe_subscription_schedule.stripe_subscription_id).to eq nil
    end

    it "creates a activity for canceled", :aggregate_failures do
      expect { PublicActivity.with_tracking { stripe_event } }
        .to change(StripeSubscriptionSchedule, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_subscription_schedule.canceled"), :count).by(1)
    end

    it "creates the subscription_schedule_phases", :aggregate_failures do
      expect { stripe_event }
        .to change(StripeSubscriptionSchedulePhase, :count).by(1)

      expect(stripe_subscription_schedule_phase.stripe_subscription_schedule_id).to eq "sub_sched_1GhwDXJ3a8kmO8fmxeer3WCy"

      expect(stripe_subscription_schedule_phase.application_fee_percent).to eq nil
      expect(stripe_subscription_schedule_phase.billing_thresholds_amount_gte).to eq nil
      expect(stripe_subscription_schedule_phase.billing_thresholds_reset_billing_cycle_anchor).to eq nil
      expect(stripe_subscription_schedule_phase.collection_method).to eq "charge_automatically"
      expect(stripe_subscription_schedule_phase.stripe_coupon_id).to eq nil
      expect(stripe_subscription_schedule_phase.default_payment_method).to eq nil
      expect(stripe_subscription_schedule_phase.end_date).to eq Time.zone.parse("2020-12-01 00:00:00")
      expect(stripe_subscription_schedule_phase.invoice_settings_days_until_due).to eq nil
      expect(stripe_subscription_schedule_phase.prorate).to eq true
      expect(stripe_subscription_schedule_phase.proration_behavior).to eq "create_prorations"
      expect(stripe_subscription_schedule_phase.start_date).to eq Time.zone.parse("2020-06-01 00:00:00")
      expect(stripe_subscription_schedule_phase.trial_end).to eq nil
    end

    it "creates the subscription_schedule_phase_plan", :aggregate_failures do
      expect { stripe_event }
        .to change(StripeSubscriptionSchedulePhasePlan, :count).by(1)

      expect(stripe_subscription_schedule_phase_plan.billing_thresholds_usage_gte).to eq nil
      expect(stripe_subscription_schedule_phase_plan.stripe_plan_id).to eq "plan_HG4dIu1k8KqRWi"
      expect(stripe_subscription_schedule_phase_plan.stripe_price_id).to eq "plan_HG4dIu1k8KqRWi"
      expect(stripe_subscription_schedule_phase_plan.quantity).to eq 1
    end
  end
end

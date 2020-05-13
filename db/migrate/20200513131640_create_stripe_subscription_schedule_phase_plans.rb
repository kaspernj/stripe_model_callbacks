class CreateStripeSubscriptionSchedulePhasePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_subscription_schedule_phase_plans do |t|
      t.string :stripe_subscription_schedule_phase_id, index: {name: "index_subscription_schedule_phase_plans_on_schedule_phase_id"}, null: false
      t.integer :billing_thresholds_usage_gte
      t.string :stripe_plan_id, index: {name: "index_subscription_schedule_phase_plans_on_stripe_plan_id"}
      t.string :stripe_price_id, index: {name: "index_subscription_schedule_phase_plans_on_stripe_price_id"}
      t.integer :quantity
    end
  end
end

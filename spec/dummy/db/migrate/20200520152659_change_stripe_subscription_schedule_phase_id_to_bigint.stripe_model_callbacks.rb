# This migration comes from stripe_model_callbacks (originally 20200520152604)
class ChangeStripeSubscriptionSchedulePhaseIdToBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :stripe_subscription_schedule_phase_plans, :stripe_subscription_schedule_phase_id, :bigint
  end
end

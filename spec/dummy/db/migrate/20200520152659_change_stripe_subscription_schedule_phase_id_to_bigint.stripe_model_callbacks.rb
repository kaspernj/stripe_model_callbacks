# This migration comes from stripe_model_callbacks (originally 20200520152604)
class ChangeStripeSubscriptionSchedulePhaseIdToBigint < ActiveRecord::Migration[6.0]
  def change
    if postgres?
      change_column(
        :stripe_subscription_schedule_phase_plans,
        :stripe_subscription_schedule_phase_id,
        "bigint USING stripe_subscription_schedule_phase_id::bigint"
      )
    else
      change_column :stripe_subscription_schedule_phase_plans, :stripe_subscription_schedule_phase_id, :bigint
    end
  end

  def postgres?
    %w[PostGIS Postgres].include?(ActiveRecord::Base.connection.adapter_name)
  end
end

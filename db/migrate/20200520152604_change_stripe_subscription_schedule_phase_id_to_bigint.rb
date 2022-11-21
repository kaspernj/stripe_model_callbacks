class ChangeStripeSubscriptionSchedulePhaseIdToBigint < ActiveRecord::Migration[6.0]
  def change
    if postgres?
      change_column( # rubocop:disable Rails/ReversibleMigration
        :stripe_subscription_schedule_phase_plans,
        :stripe_subscription_schedule_phase_id,
        "bigint USING stripe_subscription_schedule_phase_id::bigint"
      )
    elsif mysql?
      change_column( # rubocop:disable Rails/ReversibleMigration
        :stripe_subscription_schedule_phase_plans,
        :stripe_subscription_schedule_phase_id,
        "bigint USING CAST(stripe_subscription_schedule_phase_id AS bigint)"
      )
    else
      change_column :stripe_subscription_schedule_phase_plans, :stripe_subscription_schedule_phase_id, :bigint # rubocop:disable Rails/ReversibleMigration
    end
  end

  def mysql?
    ActiveRecord::Base.connection.adapter_name.downcase.include?("mysql")
  end

  def postgres?
    %w[PostGIS Postgres].include?(ActiveRecord::Base.connection.adapter_name)
  end
end

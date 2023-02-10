class CreateStripeSetupIntents < ActiveRecord::Migration[7.0]
  def change
    create_table :stripe_setup_intents do |t|
      t.string :stripe_id, index: {unique: true}, null: false
      t.string :application
      t.string :cancellation_reason
      t.string :client_secret
      t.datetime :created
      t.string :customer, index: true
      t.string :description
      t.json :flow_directions
      t.string :last_setup_error
      t.string :latest_attempt
      t.boolean :livemode
      t.json :mandate
      t.json :metadata
      t.string :next_action
      t.string :on_behalf_of
      t.json :payment_method
      t.json :payment_method_options
      t.json :payment_method_types
      t.string :single_use_mandate
      t.string :status
      t.string :usage
      t.timestamps
    end
  end
end

# This migration comes from stripe_model_callbacks (originally 20230421072509)
class CreateStripePaymentIntents < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/AbcSize
    create_table :stripe_payment_intents do |t|
      t.string :stripe_id, index: {unique: true}, null: false
      t.integer :amount
      t.integer :amount_capturable
      t.json :amount_details
      t.integer :amount_received
      t.string :application
      t.integer :application_fee_amount
      t.json :automatic_payment_methods
      t.integer :canceled_at
      t.string :cancellation_reason
      t.string :capture_method
      t.string :client_secret
      t.string :confirmation_method
      t.integer :created
      t.string :currency
      t.string :customer, index: true
      t.text :description
      t.string :invoice
      t.json :last_payment_error
      t.string :latest_charge, index: true
      t.boolean :livemode
      t.json :metadata
      t.json :next_action
      t.string :on_behalf_of, index: true
      t.string :payment_method, index: true
      t.json :payment_method_options
      t.json :payment_method_types
      t.json :processing
      t.string :receipt_email
      t.string :review, index: true
      t.string :setup_future_usage
      t.json :shipping
      t.string :statement_descriptor
      t.string :statement_descriptor_suffix
      t.string :status
      t.json :transfer_data
      t.string :transfer_group
      t.timestamps
    end
  end
end

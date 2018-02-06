# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180206151132) do

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.string "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "stripe_charges", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.integer "amount_refunded_cents"
    t.string "amount_refunded_currency"
    t.integer "application_cents"
    t.string "application_currency"
    t.string "currency", null: false
    t.boolean "captured", null: false
    t.boolean "paid", null: false
    t.string "dispute"
    t.string "failure_code"
    t.string "failure_message"
    t.text "fraud_details"
    t.text "outcome"
    t.boolean "refunded", null: false
    t.string "review"
    t.string "description"
    t.string "stripe_customer_id"
    t.string "stripe_order_id"
    t.string "stripe_source_id"
    t.string "stripe_invoice_id"
    t.string "on_behalf_of"
    t.string "receipt_email"
    t.string "receipt_number"
    t.text "shipping"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "source_transfer"
    t.string "statement_descriptor"
    t.string "status"
    t.string "transfer_group"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_customer_id"], name: "index_stripe_charges_on_stripe_customer_id"
    t.index ["stripe_invoice_id"], name: "index_stripe_charges_on_stripe_invoice_id"
    t.index ["stripe_order_id"], name: "index_stripe_charges_on_stripe_order_id"
    t.index ["stripe_source_id"], name: "index_stripe_charges_on_stripe_source_id"
  end

  create_table "stripe_coupons", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_off_cents"
    t.string "amount_off_currency"
    t.datetime "created"
    t.datetime "deleted_at"
    t.string "currency"
    t.string "duration"
    t.integer "duration_in_months"
    t.boolean "livemode", default: true, null: false
    t.integer "max_redemptions"
    t.text "metadata"
    t.integer "percent_off"
    t.datetime "redeem_by"
    t.integer "times_redeemed"
    t.boolean "stripe_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_coupons_on_deleted_at"
  end

  create_table "stripe_customers", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "account_balance", null: false
    t.string "business_vat_id"
    t.datetime "deleted_at"
    t.string "currency"
    t.string "default_source"
    t.boolean "delinquent", null: false
    t.string "description"
    t.text "discount"
    t.string "email"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.text "shipping"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_customers_on_deleted_at"
  end

  create_table "stripe_discounts", force: :cascade do |t|
    t.string "stripe_coupon_id"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "coupon_amount_off_cents"
    t.string "coupon_amount_off_currency"
    t.string "coupon_currency"
    t.datetime "coupon_created"
    t.string "coupon_duration"
    t.integer "coupon_duration_in_months"
    t.boolean "coupon_livemode"
    t.integer "coupon_max_redemptions"
    t.text "coupon_metadata"
    t.integer "coupon_percent_off"
    t.integer "coupon_redeem_by"
    t.integer "coupon_times_redeemed"
    t.boolean "coupon_valid"
    t.datetime "created"
    t.datetime "deleted_at"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_coupon_id"], name: "index_stripe_discounts_on_stripe_coupon_id"
    t.index ["stripe_customer_id"], name: "index_stripe_discounts_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_stripe_discounts_on_stripe_subscription_id"
  end

  create_table "stripe_disputes", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.datetime "created"
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "balance_transaction_id"
    t.string "stripe_charge_id"
    t.string "currency"
    t.text "evidence_access_activity_log"
    t.text "evidence_billing_address"
    t.text "evidence_cancellation_policy"
    t.text "evidence_cancellation_policy_disclosure"
    t.text "evidence_cancellation_rebuttal"
    t.text "evidence_duplicate_charge_documentation"
    t.text "evidence_duplicate_charge_explanation"
    t.string "evidence_duplicate_charge_id"
    t.text "evidence_customer_communication"
    t.string "evidence_customer_email_address"
    t.string "evidence_customer_name"
    t.string "evidence_customer_purchase_ip"
    t.text "evidence_customer_signature"
    t.text "evidence_product_description"
    t.text "evidence_receipt"
    t.text "evidence_refund_policy"
    t.text "evidence_refund_policy_disclosure"
    t.text "evidence_refund_refusal_explanation"
    t.text "evidence_service_date"
    t.text "evidence_service_documentation"
    t.text "evidence_shipping_address"
    t.text "evidence_shipping_carrier"
    t.text "evidence_shipping_date"
    t.text "evidence_shipping_documentation"
    t.text "evidence_shipping_tracking_number"
    t.text "evidence_uncategorized_file"
    t.text "evidence_uncategorized_text"
    t.datetime "evidence_details_due_by"
    t.boolean "evidence_details_has_evidence"
    t.boolean "evidence_details_past_due"
    t.integer "evidence_details_submission_count"
    t.boolean "is_charge_refundable"
    t.boolean "livemode"
    t.text "metadata"
    t.string "reason"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance_transaction_id"], name: "index_stripe_disputes_on_balance_transaction_id"
    t.index ["stripe_charge_id"], name: "index_stripe_disputes_on_stripe_charge_id"
  end

  create_table "stripe_invoice_items", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "stripe_customer_id"
    t.string "currency", null: false
    t.date "datetime"
    t.datetime "deleted_at"
    t.string "description"
    t.boolean "discountable", null: false
    t.string "stripe_invoice_id"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string "stripe_plan_id"
    t.boolean "proration", null: false
    t.integer "quantity"
    t.string "stripe_subscription_id"
    t.string "subscription_item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_invoice_items_on_deleted_at"
    t.index ["stripe_customer_id"], name: "index_stripe_invoice_items_on_stripe_customer_id"
    t.index ["stripe_invoice_id"], name: "index_stripe_invoice_items_on_stripe_invoice_id"
    t.index ["stripe_plan_id"], name: "index_stripe_invoice_items_on_stripe_plan_id"
    t.index ["stripe_subscription_id"], name: "index_stripe_invoice_items_on_stripe_subscription_id"
  end

  create_table "stripe_invoices", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_due_cents", null: false
    t.string "amount_due_currency", null: false
    t.integer "application_fee_cents"
    t.string "application_fee_currency"
    t.string "billing", null: false
    t.integer "discount_cents"
    t.string "discount_currency"
    t.integer "ending_balance_cents"
    t.integer "ending_balance_currency"
    t.string "stripe_charge_id"
    t.string "currency", null: false
    t.integer "subtotal_cents"
    t.string "subtotal_currency"
    t.integer "tax_cents"
    t.string "tax_currency"
    t.decimal "tax_percent"
    t.integer "total_cents"
    t.string "total_currency"
    t.string "stripe_customer_id", null: false
    t.string "description"
    t.boolean "forgiven", null: false
    t.string "receipt_number"
    t.string "stripe_subscription_id"
    t.boolean "attempted", null: false
    t.datetime "next_payment_attempt"
    t.boolean "closed", null: false
    t.datetime "date", null: false
    t.datetime "due_date"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "number"
    t.boolean "paid", null: false
    t.datetime "period_start"
    t.datetime "period_end"
    t.integer "starting_balance_cents"
    t.string "starting_balance_currency"
    t.string "statement_descriptor"
    t.datetime "subscription_proration_date"
    t.datetime "webhooks_delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_charge_id"], name: "index_stripe_invoices_on_stripe_charge_id"
    t.index ["stripe_customer_id"], name: "index_stripe_invoices_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_stripe_invoices_on_stripe_subscription_id"
  end

  create_table "stripe_order_items", force: :cascade do |t|
    t.string "parent_id", null: false
    t.string "stripe_order_id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.string "currency", null: false
    t.string "description"
    t.integer "quantity"
    t.string "order_item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_stripe_order_items_on_parent_id"
    t.index ["stripe_order_id"], name: "index_stripe_order_items_on_stripe_order_id"
  end

  create_table "stripe_orders", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.integer "amount_returned_cents"
    t.string "amount_returned_currency"
    t.integer "application_cents"
    t.string "application_currency"
    t.integer "application_fee"
    t.string "stripe_charge_id"
    t.string "currency", null: false
    t.string "stripe_customer_id"
    t.string "email"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "selected_shipping_method"
    t.string "shipping_address_city"
    t.string "shipping_address_country"
    t.string "shipping_address_line1"
    t.string "shipping_address_line2"
    t.string "shipping_address_postal_code"
    t.string "shipping_address_state"
    t.string "shipping_carrier"
    t.string "shipping_name"
    t.string "shipping_phone"
    t.string "shipping_tracking_number"
    t.string "shipping_methods"
    t.string "status", null: false
    t.datetime "created"
    t.datetime "updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_charge_id"], name: "index_stripe_orders_on_stripe_charge_id"
    t.index ["stripe_customer_id"], name: "index_stripe_orders_on_stripe_customer_id"
  end

  create_table "stripe_payouts", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.datetime "arrival_date"
    t.boolean "automatic"
    t.string "balance_transaction"
    t.datetime "created"
    t.string "currency"
    t.string "description"
    t.string "destination"
    t.string "failure_balance_transaction"
    t.string "failure_code"
    t.string "failure_message"
    t.boolean "livemode"
    t.text "metadata"
    t.string "stripe_method"
    t.string "source_type"
    t.string "statement_descriptor"
    t.string "status"
    t.string "stripe_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_plans", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.string "currency", null: false
    t.string "interval", null: false
    t.integer "interval_count", null: false
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "name", null: false
    t.string "statement_descriptor"
    t.integer "trial_period_days"
    t.datetime "deleted_at"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_plans_on_deleted_at"
  end

  create_table "stripe_products", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.boolean "active", default: false, null: false
    t.datetime "deleted_at"
    t.text "stripe_attributes"
    t.string "caption"
    t.string "description"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "name"
    t.decimal "package_dimensions_height"
    t.decimal "package_dimensions_length"
    t.decimal "package_dimensions_weight"
    t.decimal "package_dimensions_width"
    t.boolean "shippable", default: false, null: false
    t.string "statement_descriptor"
    t.text "url"
    t.datetime "created"
    t.datetime "updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_products_on_deleted_at"
  end

  create_table "stripe_recipients", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "active_account"
    t.string "description"
    t.datetime "deleted_at"
    t.string "name"
    t.string "email"
    t.boolean "livemode", default: true, null: false
    t.string "stripe_type"
    t.text "metadata"
    t.string "migrated_to"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_recipients_on_deleted_at"
  end

  create_table "stripe_refunds", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "balance_transaction"
    t.string "stripe_charge_id", null: false
    t.string "currency", null: false
    t.string "failure_balance_transaction"
    t.string "failure_reason"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "reason"
    t.string "receipt_number"
    t.string "status"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_skus", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.boolean "active", default: false, null: false
    t.datetime "deleted_at"
    t.text "stripe_attributes"
    t.string "currency", null: false
    t.integer "inventory_quantity"
    t.string "inventory_type"
    t.string "inventory_value"
    t.boolean "livemode"
    t.text "metadata"
    t.integer "price_cents"
    t.string "price_currency"
    t.string "stripe_product_id"
    t.datetime "created"
    t.datetime "updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_skus_on_deleted_at"
    t.index ["stripe_product_id"], name: "index_stripe_skus_on_stripe_product_id"
  end

  create_table "stripe_sources", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "client_secret", null: false
    t.string "currency"
    t.string "flow", null: false
    t.boolean "livemode", default: true, null: false
    t.string "metadata"
    t.string "owner_address_city"
    t.string "owner_address_country"
    t.string "owner_address_line1"
    t.string "owner_address_line2"
    t.string "owner_address_postal_code"
    t.string "owner_address_state"
    t.string "owner_email"
    t.string "owner_name"
    t.string "owner_phone"
    t.string "owner_verified_address_city"
    t.string "owner_verified_address_country"
    t.string "owner_verified_address_line1"
    t.string "owner_verified_address_line2"
    t.string "owner_verified_address_postal_code"
    t.string "owner_verified_address_state"
    t.string "owner_verified_email"
    t.string "owner_verified_name"
    t.string "owner_verified_phone"
    t.string "receiver_address"
    t.integer "receiver_amount_charged_cents"
    t.string "receiver_amount_charged_currency"
    t.integer "receiver_amount_received_cents"
    t.string "receiver_amount_received_currency"
    t.integer "receiver_amount_returned_cents"
    t.string "receiver_amount_returned_currency"
    t.string "receiver_refund_attributes_method"
    t.string "receiver_refund_attributes_status"
    t.string "redirect_failure_reason"
    t.string "redirect_return_url"
    t.string "redirect_status"
    t.text "redirect_url"
    t.string "statement_descriptor"
    t.string "status"
    t.string "stripe_type"
    t.string "usage"
    t.string "ach_credit_transfer_account_number"
    t.string "ach_credit_transfer_routing_number"
    t.string "ach_credit_transfer_fingerprint"
    t.string "ach_credit_transfer_bank_name"
    t.string "ach_credit_transfer_swift_code"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_subscriptions", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "application_fee_percent"
    t.string "billing"
    t.boolean "cancel_at_period_end"
    t.datetime "canceled_at"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.string "stripe_customer_id"
    t.integer "days_until_due"
    t.string "discount"
    t.datetime "ended_at"
    t.boolean "livemode", default: true
    t.text "metadata"
    t.string "stripe_plan_id"
    t.integer "quantity"
    t.datetime "start"
    t.integer "tax_percent"
    t.string "status"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "deleted_at"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_stripe_subscriptions_on_deleted_at"
    t.index ["discount"], name: "index_stripe_subscriptions_on_discount"
    t.index ["status"], name: "index_stripe_subscriptions_on_status"
    t.index ["stripe_customer_id"], name: "index_stripe_subscriptions_on_stripe_customer_id"
    t.index ["stripe_plan_id"], name: "index_stripe_subscriptions_on_stripe_plan_id"
  end

  create_table "stripe_transfers", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.integer "amount_reversed_cents", null: false
    t.string "amount_reversed_currency", null: false
    t.string "balance_transaction"
    t.datetime "created"
    t.string "currency", null: false
    t.string "description"
    t.string "destination"
    t.string "destination_payment"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.boolean "reversed", default: false, null: false
    t.string "source_transaction"
    t.string "source_type"
    t.string "transfer_group"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

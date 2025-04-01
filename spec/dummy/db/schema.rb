# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_01_084316) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.string "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "audit_actions", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_audit_actions_on_action", unique: true
  end

  create_table "audit_auditable_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_audit_auditable_types_on_name", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "audit_action_id", null: false
    t.integer "audit_auditable_type_id", null: false
    t.string "auditable_type", null: false
    t.integer "auditable_id", null: false
    t.string "user_type"
    t.integer "user_id"
    t.json "audited_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "params"
    t.index ["audit_action_id"], name: "index_audits_on_audit_action_id"
    t.index ["audit_auditable_type_id"], name: "index_audits_on_audit_auditable_type_id"
    t.index ["auditable_type", "auditable_id"], name: "index_audits_on_auditable"
    t.index ["user_type", "user_id"], name: "index_audits_on_user"
  end

  create_table "stripe_bank_accounts", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "stripe_account_id"
    t.string "account_holder_name"
    t.string "account_holder_type"
    t.string "bank_name"
    t.string "country"
    t.string "currency"
    t.boolean "default_for_currency"
    t.string "fingerprint"
    t.string "last4"
    t.text "metadata"
    t.string "routing_number"
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["status"], name: "index_stripe_bank_accounts_on_status"
    t.index ["stripe_account_id"], name: "index_stripe_bank_accounts_on_stripe_account_id"
    t.index ["stripe_id"], name: "index_stripe_bank_accounts_on_stripe_id"
  end

  create_table "stripe_cards", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "address_city"
    t.string "address_country"
    t.string "address_line1"
    t.string "address_line1_check"
    t.string "address_line2"
    t.string "address_state"
    t.string "address_zip"
    t.string "address_zip_check"
    t.string "brand"
    t.string "country"
    t.string "stripe_customer_id"
    t.string "cvc_check"
    t.string "dynamic_last4"
    t.integer "exp_month"
    t.integer "exp_year"
    t.string "fingerprint"
    t.string "funding"
    t.string "last4"
    t.text "metadata"
    t.string "name"
    t.string "tokenization_method"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_stripe_cards_on_deleted_at"
    t.index ["stripe_customer_id"], name: "index_stripe_cards_on_stripe_customer_id"
    t.index ["stripe_id"], name: "index_stripe_cards_on_stripe_id"
  end

  create_table "stripe_charges", force: :cascade do |t|
    t.string "stripe_id", null: false
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
    t.datetime "created", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "amount_captured_cents"
    t.string "amount_captured_currency"
    t.string "payment_intent"
    t.index ["payment_intent"], name: "index_stripe_charges_on_payment_intent"
    t.index ["stripe_customer_id"], name: "index_stripe_charges_on_stripe_customer_id"
    t.index ["stripe_id"], name: "index_stripe_charges_on_stripe_id"
    t.index ["stripe_invoice_id"], name: "index_stripe_charges_on_stripe_invoice_id"
    t.index ["stripe_order_id"], name: "index_stripe_charges_on_stripe_order_id"
    t.index ["stripe_source_id"], name: "index_stripe_charges_on_stripe_source_id"
  end

  create_table "stripe_coupons", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_off_cents"
    t.string "amount_off_currency"
    t.datetime "created", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "currency"
    t.string "duration"
    t.integer "duration_in_months"
    t.boolean "livemode", default: true, null: false
    t.integer "max_redemptions"
    t.text "metadata"
    t.integer "percent_off"
    t.datetime "redeem_by", precision: nil
    t.integer "times_redeemed"
    t.boolean "stripe_valid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_stripe_coupons_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_coupons_on_stripe_id"
  end

  create_table "stripe_customers", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "balance", null: false
    t.string "business_vat_id"
    t.datetime "deleted_at", precision: nil
    t.string "currency"
    t.string "default_source"
    t.boolean "delinquent", null: false
    t.string "description"
    t.text "discount"
    t.string "email"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.text "shipping"
    t.datetime "created", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_stripe_customers_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_customers_on_stripe_id"
  end

  create_table "stripe_discounts", force: :cascade do |t|
    t.string "stripe_coupon_id"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "coupon_amount_off_cents"
    t.string "coupon_amount_off_currency"
    t.string "coupon_currency"
    t.datetime "coupon_created", precision: nil
    t.string "coupon_duration"
    t.integer "coupon_duration_in_months"
    t.boolean "coupon_livemode"
    t.integer "coupon_max_redemptions"
    t.text "coupon_metadata"
    t.integer "coupon_percent_off"
    t.integer "coupon_redeem_by"
    t.integer "coupon_times_redeemed"
    t.boolean "coupon_valid"
    t.datetime "created", precision: nil
    t.datetime "deleted_at", precision: nil
    t.datetime "start", precision: nil
    t.datetime "end", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["stripe_coupon_id"], name: "index_stripe_discounts_on_stripe_coupon_id"
    t.index ["stripe_customer_id"], name: "index_stripe_discounts_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_stripe_discounts_on_stripe_subscription_id"
  end

  create_table "stripe_disputes", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.datetime "created", precision: nil
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
    t.datetime "evidence_details_due_by", precision: nil
    t.boolean "evidence_details_has_evidence"
    t.boolean "evidence_details_past_due"
    t.integer "evidence_details_submission_count"
    t.boolean "is_charge_refundable"
    t.boolean "livemode"
    t.text "metadata"
    t.string "reason"
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["balance_transaction_id"], name: "index_stripe_disputes_on_balance_transaction_id"
    t.index ["stripe_charge_id"], name: "index_stripe_disputes_on_stripe_charge_id"
    t.index ["stripe_id"], name: "index_stripe_disputes_on_stripe_id"
  end

  create_table "stripe_invoice_items", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "stripe_customer_id"
    t.string "currency", null: false
    t.date "datetime"
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.boolean "discountable", null: false
    t.string "stripe_invoice_id"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.datetime "period_start", precision: nil
    t.datetime "period_end", precision: nil
    t.string "stripe_plan_id"
    t.boolean "proration", null: false
    t.integer "quantity"
    t.string "stripe_subscription_id"
    t.string "stripe_subscription_item_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_stripe_invoice_items_on_deleted_at"
    t.index ["stripe_customer_id"], name: "index_stripe_invoice_items_on_stripe_customer_id"
    t.index ["stripe_id"], name: "index_stripe_invoice_items_on_stripe_id"
    t.index ["stripe_invoice_id"], name: "index_stripe_invoice_items_on_stripe_invoice_id"
    t.index ["stripe_plan_id"], name: "index_stripe_invoice_items_on_stripe_plan_id"
    t.index ["stripe_subscription_id"], name: "index_stripe_invoice_items_on_stripe_subscription_id"
    t.index ["stripe_subscription_item_id"], name: "index_stripe_invoice_items_on_stripe_subscription_item_id"
  end

  create_table "stripe_invoices", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_due_cents", null: false
    t.string "amount_due_currency", null: false
    t.integer "application_fee_amount_cents"
    t.string "application_fee_amount_currency"
    t.string "billing_deprecated"
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
    t.boolean "forgiven"
    t.string "receipt_number"
    t.string "stripe_subscription_id"
    t.boolean "attempted", null: false
    t.datetime "next_payment_attempt", precision: nil
    t.boolean "closed"
    t.datetime "created", precision: nil, null: false
    t.datetime "due_date", precision: nil
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "number"
    t.boolean "paid", null: false
    t.datetime "period_start", precision: nil
    t.datetime "period_end", precision: nil
    t.integer "starting_balance_cents"
    t.string "starting_balance_currency"
    t.string "statement_descriptor"
    t.datetime "subscription_proration_date", precision: nil
    t.datetime "webhooks_delivered_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "attempt_count"
    t.integer "ending_balance"
    t.integer "starting_balance"
    t.string "stripe_discount_id"
    t.boolean "auto_advance", default: false
    t.string "billing_reason"
    t.string "status", default: "draft"
    t.datetime "finalized_at", precision: nil
    t.datetime "marked_uncollectible_at", precision: nil
    t.datetime "paid_at", precision: nil
    t.datetime "voided_at", precision: nil
    t.integer "amount_paid_cents"
    t.string "amount_paid_currency"
    t.integer "amount_remaining_cents"
    t.string "amount_remaining_currency"
    t.string "collection_method"
    t.string "hosted_invoice_url"
    t.string "invoice_pdf"
    t.index ["stripe_charge_id"], name: "index_stripe_invoices_on_stripe_charge_id"
    t.index ["stripe_customer_id"], name: "index_stripe_invoices_on_stripe_customer_id"
    t.index ["stripe_discount_id"], name: "index_stripe_invoices_on_stripe_discount_id"
    t.index ["stripe_id"], name: "index_stripe_invoices_on_stripe_id", unique: true
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_id"], name: "index_stripe_order_items_on_parent_id"
    t.index ["stripe_order_id"], name: "index_stripe_order_items_on_stripe_order_id"
  end

  create_table "stripe_orders", force: :cascade do |t|
    t.string "stripe_id", null: false
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
    t.datetime "created", precision: nil
    t.datetime "updated", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["stripe_charge_id"], name: "index_stripe_orders_on_stripe_charge_id"
    t.index ["stripe_customer_id"], name: "index_stripe_orders_on_stripe_customer_id"
    t.index ["stripe_id"], name: "index_stripe_orders_on_stripe_id"
  end

  create_table "stripe_payment_intents", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount"
    t.integer "amount_capturable"
    t.json "amount_details"
    t.integer "amount_received"
    t.string "application"
    t.integer "application_fee_amount"
    t.json "automatic_payment_methods"
    t.integer "canceled_at"
    t.string "cancellation_reason"
    t.string "capture_method"
    t.string "client_secret"
    t.string "confirmation_method"
    t.integer "created"
    t.string "currency"
    t.string "customer"
    t.text "description"
    t.string "invoice"
    t.json "last_payment_error"
    t.string "latest_charge"
    t.boolean "livemode"
    t.json "metadata"
    t.json "next_action"
    t.string "on_behalf_of"
    t.string "payment_method"
    t.json "payment_method_options"
    t.json "payment_method_types"
    t.json "processing"
    t.string "receipt_email"
    t.string "review"
    t.string "setup_future_usage"
    t.json "shipping"
    t.string "statement_descriptor"
    t.string "statement_descriptor_suffix"
    t.string "status"
    t.json "transfer_data"
    t.string "transfer_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer"], name: "index_stripe_payment_intents_on_customer"
    t.index ["latest_charge"], name: "index_stripe_payment_intents_on_latest_charge"
    t.index ["on_behalf_of"], name: "index_stripe_payment_intents_on_on_behalf_of"
    t.index ["payment_method"], name: "index_stripe_payment_intents_on_payment_method"
    t.index ["review"], name: "index_stripe_payment_intents_on_review"
    t.index ["stripe_id"], name: "index_stripe_payment_intents_on_stripe_id", unique: true
  end

  create_table "stripe_payment_methods", force: :cascade do |t|
    t.string "stripe_id"
    t.json "billing_details"
    t.json "card"
    t.json "metadata"
    t.string "customer"
    t.string "stripe_type"
    t.boolean "livemode"
    t.integer "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_payouts", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.datetime "arrival_date", precision: nil
    t.boolean "automatic"
    t.string "balance_transaction"
    t.datetime "created", precision: nil
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["stripe_id"], name: "index_stripe_payouts_on_stripe_id"
  end

  create_table "stripe_plans", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.string "currency", null: false
    t.string "interval", null: false
    t.integer "interval_count", null: false
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "statement_descriptor"
    t.integer "trial_period_days"
    t.datetime "deleted_at", precision: nil
    t.datetime "created", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "stripe_product_id"
    t.string "nickname"
    t.boolean "active"
    t.string "aggregate_usage"
    t.string "amount_decimal"
    t.string "billing_scheme"
    t.string "usage_type"
    t.index ["deleted_at"], name: "index_stripe_plans_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_plans_on_stripe_id"
    t.index ["stripe_product_id"], name: "index_stripe_plans_on_stripe_product_id"
  end

  create_table "stripe_prices", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "active"
    t.string "billing_scheme"
    t.datetime "created", precision: nil
    t.string "currency"
    t.string "lookup_key"
    t.json "metadata"
    t.string "nickname"
    t.string "stripe_product_id"
    t.boolean "recurring_aggregate_usage"
    t.string "recurring_interval"
    t.integer "recurring_interval_count"
    t.string "recurring_usage_type"
    t.string "tiers_mode"
    t.integer "transform_quantity_divide_by"
    t.string "transform_quantity_round"
    t.string "price_type"
    t.integer "unit_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_id"], name: "index_stripe_prices_on_stripe_id"
    t.index ["stripe_product_id"], name: "index_stripe_prices_on_stripe_product_id"
  end

  create_table "stripe_products", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.boolean "active", default: false, null: false
    t.datetime "deleted_at", precision: nil
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
    t.datetime "created", precision: nil
    t.datetime "updated", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "product_type"
    t.string "unit_label"
    t.index ["deleted_at"], name: "index_stripe_products_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_products_on_stripe_id"
  end

  create_table "stripe_recipients", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "active_account"
    t.string "description"
    t.datetime "deleted_at", precision: nil
    t.string "name"
    t.string "email"
    t.boolean "livemode", default: true, null: false
    t.string "stripe_type"
    t.text "metadata"
    t.string "migrated_to"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_stripe_recipients_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_recipients_on_stripe_id"
  end

  create_table "stripe_refunds", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "balance_transaction"
    t.string "stripe_charge_id"
    t.string "currency", null: false
    t.string "failure_balance_transaction"
    t.string "failure_reason"
    t.boolean "livemode", default: true, null: false
    t.text "metadata"
    t.string "reason"
    t.string "receipt_number"
    t.string "status"
    t.datetime "created", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "payment_intent"
    t.index ["payment_intent"], name: "index_stripe_refunds_on_payment_intent"
    t.index ["stripe_charge_id"], name: "index_stripe_refunds_on_stripe_charge_id"
    t.index ["stripe_id"], name: "index_stripe_refunds_on_stripe_id"
  end

  create_table "stripe_reviews", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "stripe_charge_id"
    t.datetime "created", precision: nil
    t.boolean "livemode", default: false, null: false
    t.boolean "open", default: true, null: false
    t.string "reason"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["reason"], name: "index_stripe_reviews_on_reason"
    t.index ["stripe_charge_id"], name: "index_stripe_reviews_on_stripe_charge_id"
    t.index ["stripe_id"], name: "index_stripe_reviews_on_stripe_id"
  end

  create_table "stripe_setup_intents", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "application"
    t.string "cancellation_reason"
    t.string "client_secret"
    t.datetime "created"
    t.string "customer"
    t.string "description"
    t.json "flow_directions"
    t.string "last_setup_error"
    t.string "latest_attempt"
    t.boolean "livemode"
    t.json "mandate"
    t.json "metadata"
    t.string "next_action"
    t.string "on_behalf_of"
    t.json "payment_method_old"
    t.json "payment_method_options"
    t.json "payment_method_types"
    t.string "single_use_mandate"
    t.string "status"
    t.string "usage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.index ["customer"], name: "index_stripe_setup_intents_on_customer"
    t.index ["payment_method"], name: "index_stripe_setup_intents_on_payment_method"
    t.index ["stripe_id"], name: "index_stripe_setup_intents_on_stripe_id", unique: true
  end

  create_table "stripe_skus", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.boolean "active", default: false, null: false
    t.datetime "deleted_at", precision: nil
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
    t.datetime "created", precision: nil
    t.datetime "updated", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["deleted_at"], name: "index_stripe_skus_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_skus_on_stripe_id"
    t.index ["stripe_product_id"], name: "index_stripe_skus_on_stripe_product_id"
  end

  create_table "stripe_sources", force: :cascade do |t|
    t.string "stripe_id", null: false
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
    t.datetime "created", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_stripe_sources_on_deleted_at"
    t.index ["stripe_id"], name: "index_stripe_sources_on_stripe_id"
  end

  create_table "stripe_subscription_default_tax_rates", force: :cascade do |t|
    t.integer "stripe_subscription_id", null: false
    t.integer "stripe_tax_rate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_subscription_id"], name: "index_on_subscription"
    t.index ["stripe_tax_rate_id"], name: "index_on_tax_rate"
  end

  create_table "stripe_subscription_items", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.datetime "created", precision: nil
    t.string "stripe_subscription_id"
    t.string "stripe_plan_id"
    t.boolean "deleted", default: false, null: false
    t.text "metadata"
    t.integer "quantity"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "stripe_price_id"
    t.index ["stripe_id"], name: "index_stripe_subscription_items_on_stripe_id"
    t.index ["stripe_plan_id"], name: "index_stripe_subscription_items_on_stripe_plan_id"
    t.index ["stripe_price_id"], name: "index_stripe_subscription_items_on_stripe_price_id"
    t.index ["stripe_subscription_id"], name: "index_stripe_subscription_items_on_stripe_subscription_id"
  end

  create_table "stripe_subscription_schedule_phase_plans", force: :cascade do |t|
    t.bigint "stripe_subscription_schedule_phase_id", null: false
    t.integer "billing_thresholds_usage_gte"
    t.string "stripe_plan_id"
    t.string "stripe_price_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_plan_id"], name: "index_subscription_schedule_phase_plans_on_stripe_plan_id"
    t.index ["stripe_price_id"], name: "index_subscription_schedule_phase_plans_on_stripe_price_id"
    t.index ["stripe_subscription_schedule_phase_id"], name: "index_subscription_schedule_phase_plans_on_schedule_phase_id"
  end

  create_table "stripe_subscription_schedule_phases", force: :cascade do |t|
    t.string "stripe_subscription_schedule_id", null: false
    t.integer "application_fee_percent"
    t.integer "billing_thresholds_amount_gte"
    t.boolean "billing_thresholds_reset_billing_cycle_anchor"
    t.string "collection_method"
    t.string "stripe_coupon_id"
    t.string "default_payment_method"
    t.datetime "end_date", precision: nil
    t.integer "invoice_settings_days_until_due"
    t.boolean "prorate"
    t.string "proration_behavior"
    t.datetime "start_date", precision: nil
    t.datetime "trial_end", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_coupon_id"], name: "index_stripe_subscription_schedule_phases_on_stripe_coupon_id"
    t.index ["stripe_subscription_schedule_id"], name: "index_subscription_schedule_phases_on_subscription_schedule_id"
  end

  create_table "stripe_subscription_schedules", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "billing"
    t.integer "billing_thresholds_amount_gte"
    t.boolean "billing_thresholds_reset_billing_cycle_anchor"
    t.datetime "canceled_at", precision: nil
    t.string "collection_method"
    t.datetime "completed_at", precision: nil
    t.datetime "created", precision: nil
    t.datetime "current_phase_start_date", precision: nil
    t.datetime "current_phase_end_date", precision: nil
    t.string "stripe_customer_id"
    t.string "default_payment_method"
    t.string "default_source"
    t.string "end_behavior"
    t.integer "invoice_settings_days_until_due"
    t.boolean "livemode"
    t.text "metadata"
    t.datetime "released_at", precision: nil
    t.string "released_stripe_subscription_id"
    t.string "renewal_behavior"
    t.string "renewal_interval"
    t.string "status"
    t.string "stripe_subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_customer_id"], name: "index_stripe_subscription_schedules_on_stripe_customer_id"
    t.index ["stripe_id"], name: "index_stripe_subscription_schedules_on_stripe_id", unique: true
    t.index ["stripe_subscription_id"], name: "index_stripe_subscription_schedules_on_stripe_subscription_id"
  end

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "application_fee_percent"
    t.string "billing"
    t.boolean "cancel_at_period_end"
    t.datetime "canceled_at", precision: nil
    t.datetime "current_period_start", precision: nil
    t.datetime "current_period_end", precision: nil
    t.string "stripe_customer_id"
    t.integer "days_until_due"
    t.string "stripe_discount_id"
    t.datetime "ended_at", precision: nil
    t.boolean "livemode", default: true
    t.text "metadata"
    t.string "stripe_plan_id"
    t.integer "quantity"
    t.datetime "start_date", precision: nil
    t.integer "tax_percent"
    t.string "status"
    t.datetime "trial_start", precision: nil
    t.datetime "trial_end", precision: nil
    t.datetime "deleted_at", precision: nil
    t.datetime "created", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "latest_stripe_invoice_id"
    t.index ["deleted_at"], name: "index_stripe_subscriptions_on_deleted_at"
    t.index ["latest_stripe_invoice_id"], name: "index_stripe_subscriptions_on_latest_stripe_invoice_id"
    t.index ["status"], name: "index_stripe_subscriptions_on_status"
    t.index ["stripe_customer_id"], name: "index_stripe_subscriptions_on_stripe_customer_id"
    t.index ["stripe_discount_id"], name: "index_stripe_subscriptions_on_stripe_discount_id"
    t.index ["stripe_id"], name: "index_stripe_subscriptions_on_stripe_id"
    t.index ["stripe_plan_id"], name: "index_stripe_subscriptions_on_stripe_plan_id"
  end

  create_table "stripe_tax_rates", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "display_name"
    t.text "description"
    t.string "jurisdiction"
    t.float "percentage"
    t.boolean "inclusive"
    t.boolean "active"
    t.datetime "created", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tax_type"
    t.string "country"
    t.index ["stripe_id"], name: "index_stripe_tax_rates_on_stripe_id"
  end

  create_table "stripe_transfers", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.integer "amount_reversed_cents", null: false
    t.string "amount_reversed_currency", null: false
    t.string "balance_transaction"
    t.datetime "created", precision: nil
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["stripe_id"], name: "index_stripe_transfers_on_stripe_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audits", "audit_actions"
  add_foreign_key "audits", "audit_auditable_types"
  add_foreign_key "stripe_subscription_default_tax_rates", "stripe_subscriptions"
  add_foreign_key "stripe_subscription_default_tax_rates", "stripe_tax_rates"
end

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

ActiveRecord::Schema.define(version: 20180205140210) do

  create_table "stripe_charges", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.integer "amount_refunded_cents"
    t.string "amount_refunded_currency"
    t.integer "application_cents"
    t.string "application_currency"
    t.boolean "captured", null: false
    t.string "currency", null: false
    t.string "customer_identifier"
    t.string "description"
    t.string "dispute"
    t.string "failure_code"
    t.string "failure_message"
    t.text "fraud_details"
    t.string "invoice_identifier"
    t.boolean "livemode", null: false
    t.text "metadata"
    t.string "on_behalf_of"
    t.string "order_identifier"
    t.text "outcome"
    t.boolean "paid", null: false
    t.string "receipt_email"
    t.string "receipt_number"
    t.boolean "refunded", null: false
    t.string "review"
    t.text "shipping"
    t.string "source_identifier"
    t.string "source_transfer"
    t.string "statement_descriptor"
    t.string "status"
    t.string "transfer_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_identifier"], name: "index_stripe_charges_on_customer_identifier"
    t.index ["identifier"], name: "index_stripe_charges_on_identifier"
    t.index ["invoice_identifier"], name: "index_stripe_charges_on_invoice_identifier"
    t.index ["order_identifier"], name: "index_stripe_charges_on_order_identifier"
    t.index ["source_identifier"], name: "index_stripe_charges_on_source_identifier"
  end

  create_table "stripe_customers", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "account_balance", null: false
    t.string "business_vat_id"
    t.datetime "created"
    t.datetime "deleted_at"
    t.string "currency"
    t.string "default_source"
    t.boolean "delinquent", null: false
    t.string "description"
    t.text "discount"
    t.string "email"
    t.boolean "livemode", null: false
    t.text "metadata"
    t.text "shipping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stripe_customers_on_identifier"
  end

  create_table "stripe_discounts", force: :cascade do |t|
    t.string "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stripe_discounts_on_identifier"
  end

  create_table "stripe_invoice_items", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "customer_identifier"
    t.string "currency", null: false
    t.date "datetime"
    t.string "description"
    t.boolean "discountable", null: false
    t.string "invoice_identifier"
    t.boolean "livemode", null: false
    t.text "metadata"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string "plan_identifier"
    t.boolean "proration", null: false
    t.integer "quantity"
    t.string "subscription_identifier"
    t.string "subscription_item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_identifier"], name: "index_stripe_invoice_items_on_customer_identifier"
    t.index ["identifier"], name: "index_stripe_invoice_items_on_identifier"
    t.index ["invoice_identifier"], name: "index_stripe_invoice_items_on_invoice_identifier"
    t.index ["plan_identifier"], name: "index_stripe_invoice_items_on_plan_identifier"
    t.index ["subscription_identifier"], name: "index_stripe_invoice_items_on_subscription_identifier"
  end

  create_table "stripe_invoices", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "amount_due_cents", null: false
    t.string "amount_due_currency", null: false
    t.integer "application_fee_cents"
    t.string "application_fee_currency"
    t.boolean "attempted", null: false
    t.string "billing", null: false
    t.string "charge_identifier"
    t.boolean "closed", null: false
    t.string "currency", null: false
    t.string "customer_identifier", null: false
    t.datetime "date", null: false
    t.string "description"
    t.integer "discount_cents"
    t.string "discount_currency"
    t.datetime "due_date"
    t.integer "ending_balance_cents"
    t.integer "ending_balance_currency"
    t.boolean "forgiven", null: false
    t.boolean "livemode", null: false
    t.text "metadata"
    t.datetime "next_payment_attempt"
    t.string "number"
    t.boolean "paid", null: false
    t.datetime "period_start"
    t.datetime "period_end"
    t.string "receipt_number"
    t.integer "starting_balance_cents"
    t.string "starting_balance_currency"
    t.string "statement_descriptor"
    t.string "subscription_identifier"
    t.datetime "subscription_proration_date"
    t.integer "subtotal_cents"
    t.string "subtotal_currency"
    t.integer "tax_cents"
    t.string "tax_currency"
    t.decimal "tax_percent"
    t.integer "total_cents"
    t.string "total_currency"
    t.datetime "webhooks_delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_identifier"], name: "index_stripe_invoices_on_charge_identifier"
    t.index ["customer_identifier"], name: "index_stripe_invoices_on_customer_identifier"
    t.index ["identifier"], name: "index_stripe_invoices_on_identifier"
    t.index ["subscription_identifier"], name: "index_stripe_invoices_on_subscription_identifier"
  end

  create_table "stripe_order_items", force: :cascade do |t|
    t.string "parent_identifier", null: false
    t.string "order_identifier", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.string "currency", null: false
    t.string "description"
    t.integer "quantity"
    t.string "order_item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_identifier"], name: "index_stripe_order_items_on_order_identifier"
    t.index ["parent_identifier"], name: "index_stripe_order_items_on_parent_identifier"
  end

  create_table "stripe_orders", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.integer "amount_returned_cents"
    t.string "amount_returned_currency"
    t.integer "application_cents"
    t.string "application_currency"
    t.integer "application_fee"
    t.string "charge_identifier"
    t.string "currency", null: false
    t.string "customer_identifier"
    t.string "email"
    t.boolean "livemode", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_identifier"], name: "index_stripe_orders_on_charge_identifier"
    t.index ["customer_identifier"], name: "index_stripe_orders_on_customer_identifier"
    t.index ["identifier"], name: "index_stripe_orders_on_identifier"
  end

  create_table "stripe_plans", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "amount_cents", null: false
    t.string "amount_currency", null: false
    t.string "currency", null: false
    t.string "interval", null: false
    t.integer "interval_count", null: false
    t.boolean "livemode", null: false
    t.text "metadata"
    t.string "name", null: false
    t.string "statement_descriptor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stripe_plans_on_identifier"
  end

  create_table "stripe_sources", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "amount_cents"
    t.string "amount_currency"
    t.string "client_secret", null: false
    t.string "currency"
    t.string "flow", null: false
    t.boolean "livemode", null: false
    t.string "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stripe_sources_on_identifier"
  end

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "application_fee_percent"
    t.string "billing", null: false
    t.boolean "cancel_at_period_end", null: false
    t.datetime "canceled_at"
    t.datetime "current_period_start", null: false
    t.datetime "current_period_end", null: false
    t.string "customer_identifier", null: false
    t.integer "days_until_due"
    t.string "discount"
    t.datetime "ended_at"
    t.boolean "livemode", null: false
    t.text "metadata"
    t.string "plan_identifier", null: false
    t.integer "quantity"
    t.datetime "start", null: false
    t.integer "tex_percent"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_identifier"], name: "index_stripe_subscriptions_on_customer_identifier"
    t.index ["discount"], name: "index_stripe_subscriptions_on_discount"
    t.index ["identifier"], name: "index_stripe_subscriptions_on_identifier"
    t.index ["plan_identifier"], name: "index_stripe_subscriptions_on_plan_identifier"
  end

end

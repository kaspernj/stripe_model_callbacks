require "rails_helper"

describe "invoice created" do
  let!(:stripe_coupon) { create :stripe_coupon, stripe_id: "some-coupon" }
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }

  describe "#execute!" do
    it "creates an invoice" do
      expect { mock_stripe_event("invoice.created") }
        .to change(StripeInvoice, :count).by(1)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(Activity.where(key: "stripe_invoice.create"), :count).by(1)

      created_invoice = StripeInvoice.last

      expect(response).to have_http_status :ok

      expect(created_invoice).to have_attributes(
        stripe_id: "in_00000000000000",
        application_fee_amount: nil,
        attempt_count: 1,
        attempted: false,
        billing_deprecated: nil,
        stripe_charge_id: "ch_00000000000000",
        collection_method: "charge_automatically",
        closed: true,
        currency: "dkk",
        stripe_customer_id: "cus_00000000000000",
        created: Time.zone.parse("2018-02-04 17:02:25"),
        description: nil,
        stripe_discount: nil,
        due_date: nil,
        forgiven: false,
        next_payment_attempt: nil,
        number: "a04598880b-0007",
        paid: true,
        period_end: Time.zone.parse("2018-02-04 17:02:25"),
        period_start: Time.zone.parse("2018-02-04 17:02:25"),
        receipt_number: nil,
        starting_balance: 0,
        statement_descriptor: nil
      )
      expect(created_invoice.amount_due.format).to eq "35.00 kr."
      expect(created_invoice.amount_paid.format).to eq "35.00 kr."
      expect(created_invoice.amount_remaining.format).to eq "0.00 kr."


      expect(created_invoice.stripe_subscription_id).to eq "sub_00000000000000"
      expect(created_invoice.subtotal.format).to eq "35.00 kr."
      expect(created_invoice.tax).to be_nil
      expect(created_invoice.tax_percent).to be_nil
      expect(created_invoice.total.format).to eq "35.00 kr."
      expect(created_invoice.invoice_pdf).to be_nil
      expect(created_invoice.hosted_invoice_url).to be_nil
      # VERSION 2019-05-16
      expect(created_invoice.auto_advance).to be false
      expect(created_invoice.billing_reason).to eq "subscription_create"
      expect(created_invoice.status).to eq "draft"
      # VERSION 2019-05-16 - status_transitions
      expect(created_invoice.finalized_at).to be_nil
      expect(created_invoice.marked_uncollectible_at).to be_nil
      expect(created_invoice.paid_at).to be_nil
      expect(created_invoice.voided_at).to be_nil
    end

    it "sets the discount reference if given" do
      stripe_event = proc {
        mock_stripe_event(
          "invoice.created",
          data: {
            object: {
              discount: {
                object: "discount",
                customer: "cus_CLI9d5IHGcdWBY",
                end: nil,
                start: 1_518_896_595,
                subscription: "sub_CLIA1HwHyqUO2L",
                coupon: {
                  id: stripe_coupon.stripe_id,
                  object: "coupon",
                  amount_off: nil,
                  created: 1_518_896_553,
                  currency: "",
                  duration: "forever",
                  duration_in_months: "",
                  livemode: "true",
                  max_redemptions: "",
                  percent_off: "100",
                  redeem_by: nil,
                  times_redeemed: "1",
                  valid: "true"
                }
              }
            }
          }
        )
      }

      expect { stripe_event.call }
        .to change(StripeInvoice, :count).by(1)
        .and change(StripeDiscount, :count).by(1)

      created_invoice = StripeInvoice.last
      created_discount = StripeDiscount.last

      expect(created_invoice.stripe_discount).to eq created_discount
      expect(created_discount.stripe_coupon).to eq stripe_coupon
    end
  end
end

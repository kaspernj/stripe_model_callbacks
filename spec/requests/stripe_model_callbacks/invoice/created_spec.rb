require "rails_helper"

describe "invoice created" do
  let!(:stripe_coupon) { create :stripe_coupon, stripe_id: "some-coupon" }
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }

  describe "#execute!" do
    it "creates an invoice" do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.created") } }
        .to change(StripeInvoice, :count).by(1)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.create"), :count).by(1)

      created_invoice = StripeInvoice.last

      expect(response.code).to eq "200"

      expect(created_invoice.stripe_id).to eq "in_00000000000000"
      expect(created_invoice.amount_due.format).to eq "35.00 kr."
      expect(created_invoice.amount_paid.format).to eq "35.00 kr."
      expect(created_invoice.amount_remaining.format).to eq "0.00 kr."
      expect(created_invoice.application_fee_amount).to eq nil
      expect(created_invoice.attempt_count).to eq 1
      expect(created_invoice.attempted?).to eq false
      expect(created_invoice.billing).to eq "charge_automatically"
      expect(created_invoice.stripe_charge_id).to eq "ch_00000000000000"
      expect(created_invoice.collection_method).to eq "charge_automatically"
      expect(created_invoice.closed?).to eq true
      expect(created_invoice.currency).to eq "dkk"
      expect(created_invoice.stripe_customer_id).to eq "cus_00000000000000"
      expect(created_invoice.created).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.description).to eq nil
      expect(created_invoice.stripe_discount).to eq nil
      expect(created_invoice.due_date).to eq nil
      expect(created_invoice.forgiven?).to eq false
      expect(created_invoice.next_payment_attempt).to eq nil
      expect(created_invoice.number).to eq "a04598880b-0007"
      expect(created_invoice.paid?).to eq true
      expect(created_invoice.period_end).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.period_start).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.receipt_number).to eq nil
      expect(created_invoice.starting_balance).to eq 0
      expect(created_invoice.statement_descriptor).to eq nil
      expect(created_invoice.stripe_subscription_id).to eq "sub_00000000000000"
      expect(created_invoice.subtotal.format).to eq "35.00 kr."
      expect(created_invoice.tax).to eq nil
      expect(created_invoice.tax_percent).to eq nil
      expect(created_invoice.total.format).to eq "35.00 kr."
      expect(created_invoice.invoice_pdf).to eq nil
      expect(created_invoice.hosted_invoice_url).to eq nil
      # VERSION 2019-05-16
      expect(created_invoice.auto_advance).to eq false
      expect(created_invoice.billing_reason).to eq "subscription_create"
      expect(created_invoice.status).to eq "draft"
      # VERSION 2019-05-16 - status_transitions
      expect(created_invoice.finalized_at).to eq nil
      expect(created_invoice.marked_uncollectible_at).to eq nil
      expect(created_invoice.paid_at).to eq nil
      expect(created_invoice.voided_at).to eq nil
    end

    it "sets the discount reference if given" do
      stripe_event = proc {
        mock_stripe_event(
          "invoice.created",
          data: {
            object: {
              discount: {
                "object": "discount",
                "customer": "cus_CLI9d5IHGcdWBY",
                "end": nil,
                "start": 1_518_896_595,
                "subscription": "sub_CLIA1HwHyqUO2L",
                "coupon": {
                  "id": stripe_coupon.stripe_id,
                  "object": "coupon",
                  "amount_off": nil,
                  "created": 1_518_896_553,
                  "currency": "",
                  "duration": "forever",
                  "duration_in_months": "",
                  "livemode": "true",
                  "max_redemptions": "",
                  "percent_off": "100",
                  "redeem_by": nil,
                  "times_redeemed": "1",
                  "valid": "true"
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

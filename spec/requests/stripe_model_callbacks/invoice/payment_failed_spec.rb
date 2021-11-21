require "rails_helper"

describe "invoice payment failed" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let!(:stripe_invoice) { create :stripe_invoice, stripe_id: "in_00000000000000" }

  describe "#execute!" do
    it "updates the invoice and adds a payment failed log" do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.payment_failed") } }
        .to change(StripeInvoice, :count).by(0)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.payment_failed"), :count).by(1)

      stripe_invoice.reload

      expect(response.code).to eq "200"

      expect(stripe_invoice.stripe_id).to eq "in_00000000000000"
      expect(stripe_invoice.amount_due.format).to eq "$35.00"
      expect(stripe_invoice.amount_paid.format).to eq "$0.00"
      expect(stripe_invoice.amount_remaining.format).to eq "$35.00"
      expect(stripe_invoice.application_fee_amount).to eq nil
      expect(stripe_invoice.attempt_count).to eq 0
      expect(stripe_invoice.attempted?).to eq true
      expect(stripe_invoice.billing_deprecated).to eq nil
      expect(stripe_invoice.collection_method).to eq "charge_automatically"
      expect(stripe_invoice.stripe_charge_id).to eq nil
      expect(stripe_invoice.closed?).to eq false
      expect(stripe_invoice.currency).to eq "usd"
      expect(stripe_invoice.stripe_customer_id).to eq "cus_00000000000000"
      expect(stripe_invoice.stripe_customer).to eq stripe_customer
      expect(stripe_invoice.created).to eq Time.zone.parse("2018-02-05 16:16:02")
      expect(stripe_invoice.description).to eq nil
      expect(stripe_invoice.stripe_discount).to eq nil
      expect(stripe_invoice.due_date).to eq nil
      expect(stripe_invoice.forgiven?).to eq true
      expect(stripe_invoice.next_payment_attempt).to eq nil
      expect(stripe_invoice.number).to eq "5a331c0634-0001"
      expect(stripe_invoice.paid?).to eq false
      expect(stripe_invoice.period_end).to eq Time.zone.parse("2018-02-05 16:16:02")
      expect(stripe_invoice.period_start).to eq Time.zone.parse("2018-02-05 16:16:02")
      expect(stripe_invoice.receipt_number).to eq nil
      expect(stripe_invoice.starting_balance).to eq 0
      expect(stripe_invoice.statement_descriptor).to eq nil
      expect(stripe_invoice.stripe_subscription_id).to eq nil
      expect(stripe_invoice.subtotal.format).to eq "$0.00"
      expect(stripe_invoice.tax).to eq nil
      expect(stripe_invoice.tax_percent).to eq nil
      expect(stripe_invoice.total.format).to eq "$0.00"
      expect(stripe_invoice.invoice_pdf).to eq nil
      expect(stripe_invoice.hosted_invoice_url).to eq nil
      # VERSION 2019-05-16
      expect(stripe_invoice.auto_advance).to eq true
      expect(stripe_invoice.billing_reason).to eq "subscription_create"
      expect(stripe_invoice.status).to eq "uncollectible"
      # VERSION 2019-05-16 - status_transitions
      expect(stripe_invoice.finalized_at).to eq Time.zone.parse("2019-06-29 11:05:35")
      expect(stripe_invoice.marked_uncollectible_at).to eq nil
      expect(stripe_invoice.paid_at).to eq nil
      expect(stripe_invoice.voided_at).to eq nil
    end
  end
end

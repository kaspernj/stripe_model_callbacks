require "rails_helper"

describe "invoice upcoming" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }
  let!(:stripe_invoice) { create :stripe_invoice, stripe_id: "in_00000000000000" }

  describe "#execute!" do
    it "updates the invoice and adds a log", skip: "Upcoming event doesnt send an invoice ID. Dunno what to do about it..." do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.upcoming") } }
        .to change(StripeInvoice, :count).by(0)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.upcoming"), :count).by(1)

      created_invoice = StripeInvoice.last!

      expect(response.code).to eq "200"

      expect(created_invoice).to have_attributes(
        stripe_id: "in_00000000000000",
        application_fee_amount: nil
      )
      expect(created_invoice.attempt_count).to eq 1
      expect(created_invoice.attempted?).to be true
      expect(created_invoice.billing).to eq "charge_automatically"
      expect(created_invoice.collection_method).to eq "charge_automatically"
      expect(created_invoice.stripe_charge_id).to eq "ch_00000000000000"
      expect(created_invoice.closed?).to be true
      expect(created_invoice.currency).to eq "dkk"
      expect(created_invoice.stripe_customer_id).to eq "cus_00000000000000"
      expect(created_invoice.amount_due.format).to eq "35.00 kr."
      expect(created_invoice.amount_paid.format).to eq "35.00 kr."
      expect(created_invoice.amount_remaining.format).to eq "0.00 kr."

      expect(created_invoice.created).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.description).to be_nil
      expect(created_invoice.discount).to be_nil
      expect(created_invoice.due_date).to be_nil
      expect(created_invoice.forgiven?).to be false
      expect(created_invoice.next_payment_attempt).to be_nil
      expect(created_invoice.number).to eq "a04598880b-0007"
      expect(created_invoice.paid?).to be true
      expect(created_invoice.period_end).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.period_start).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.receipt_number).to be_nil
      expect(created_invoice.starting_balance).to eq 0
      expect(created_invoice.statement_descriptor).to be_nil
      expect(created_invoice.stripe_subscription_id).to eq "sub_00000000000000"
      expect(created_invoice.subtotal.format).to eq "35.00 kr."
      expect(created_invoice.tax).to be_nil
      expect(created_invoice.tax_percent).to be_nil
      expect(created_invoice.total.format).to eq "35.00 kr."
      expect(created_invoice.invoice_pdf).to eq "x"
      expect(created_invoice.hosted_invoice_url).to eq "x"
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
  end
end

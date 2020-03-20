require "rails_helper"

describe "invoice payment succeeded" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }

  describe "#execute!" do
    it "updates the invoice and adds a payment succeeded log" do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.payment_succeeded") } }
        .to change(StripeInvoice, :count).by(1)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.payment_succeeded"), :count).by(1)

      created_invoice = StripeInvoice.last

      expect(response.code).to eq "200"

      expect(created_invoice.stripe_id).to eq "in_1BrsEhAT5SYrvIfdlmd9sZns"
      expect(created_invoice.application_fee_amount).to eq nil
      expect(created_invoice.attempt_count).to eq 0
      expect(created_invoice.attempted?).to eq true
      expect(created_invoice.billing).to eq "charge_automatically"
      expect(created_invoice.stripe_charge_id).to eq "ch_1BrsEhAT5SYrvIfdDOd8ifsb"
      expect(created_invoice.closed?).to eq true
      expect(created_invoice.currency).to eq "dkk"
      expect(created_invoice.stripe_customer_id).to eq "cus_CGNFgjPGtHlvXI"
      expect(created_invoice.created).to eq Time.zone.parse("2018-02-04 18:29:07")
      expect(created_invoice.description).to eq nil
      expect(created_invoice.stripe_discount).to eq nil
      expect(created_invoice.due_date).to eq nil
      expect(created_invoice.forgiven?).to eq false
      expect(created_invoice.next_payment_attempt).to eq nil
      expect(created_invoice.number).to eq "a04598880b-0014"
      expect(created_invoice.paid?).to eq true
      expect(created_invoice.period_end).to eq Time.zone.parse("2018-02-04 18:29:07")
      expect(created_invoice.period_start).to eq Time.zone.parse("2018-02-04 18:29:07")
      expect(created_invoice.receipt_number).to eq nil
      expect(created_invoice.starting_balance).to eq 0
      expect(created_invoice.statement_descriptor).to eq nil
      expect(created_invoice.stripe_subscription_id).to eq "sub_CGP2EtRzfVystw"
      expect(created_invoice.subtotal.format).to eq "100.00 kr."
      expect(created_invoice.tax).to eq nil
      expect(created_invoice.tax_percent).to eq nil
      expect(created_invoice.total.format).to eq "100.00 kr."
      # VERSION 2019-05-16
      expect(created_invoice.auto_advance).to eq false
      expect(created_invoice.billing_reason).to eq "subscription_create"
      expect(created_invoice.status).to eq "draft"
      # VERSION 2019-05-16 - status_transitions
      expect(created_invoice.finalized_at).to eq Time.zone.parse("2019-06-29 11:05:35")
      expect(created_invoice.marked_uncollectible_at).to eq nil
      expect(created_invoice.paid_at).to eq Time.zone.parse("2019-06-29 11:05:37")
      expect(created_invoice.voided_at).to eq nil
    end
  end
end

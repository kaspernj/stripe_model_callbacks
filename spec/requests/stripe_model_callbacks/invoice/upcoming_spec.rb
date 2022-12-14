require "rails_helper"

describe "invoice upcoming" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }
  let!(:stripe_invoice) { create :stripe_invoice, stripe_id: "in_00000000000000" }

  describe "#execute!" do
    it "updates the invoice and adds a log" do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.upcoming") } }
        .to change(StripeInvoice, :count).by(0)

      # Upcoming event doesnt send an invoice ID. Dunno what to do about it...
      # .and change(PublicActivity::Activity.where(key: "stripe_invoice.upcoming"), :count).by(1)
      # .and change(StripeInvoiceItem, :count).by(1)

      created_invoice = StripeInvoice.last!

      expect(response.code).to eq "200"

      expect(created_invoice).to have_attributes(
        stripe_id: "in_00000000000000",
        application_fee_amount: nil,
        attempt_count: nil,
        attempted: false,
        collection_method: "charge_automatically",
        stripe_charge_id: nil,
        currency: "usd",
        number: nil,
        period_end: nil,
        period_start: nil,
        starting_balance: nil,
        stripe_subscription_id: nil,
        invoice_pdf: nil,
        hosted_invoice_url: nil,
        billing_reason: nil,
        status: "draft",
        closed: false,
        description: nil,
        due_date: nil,
        forgiven: false,
        next_payment_attempt: nil,
        paid: false,
        receipt_number: nil,
        statement_descriptor: nil,
        amount_paid: nil,
        amount_remaining: nil,
        subtotal: nil,
        tax: nil,
        tax_percent: nil,
        total: nil,
        auto_advance: false,
        finalized_at: nil,
        marked_uncollectible_at: nil,
        paid_at: nil,
        voided_at: nil
      )

      expect(created_invoice.amount_due.format).to eq "$0.00"
      expect(created_invoice.stripe_customer_id).to match(/^customer-identifier-(\d+)$/)
    end
  end
end

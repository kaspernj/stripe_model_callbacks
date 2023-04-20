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

      expect(response).to have_http_status :ok

      expect(created_invoice).to have_attributes(
        stripe_id: "in_1BrsEhAT5SYrvIfdlmd9sZns",
        application_fee_amount: nil,
        attempt_count: 0,
        attempted: true,
        billing_deprecated: nil,
        collection_method: "charge_automatically",
        stripe_charge_id: "ch_1BrsEhAT5SYrvIfdDOd8ifsb",
        closed: true,
        currency: "dkk",
        stripe_customer_id: "cus_CGNFgjPGtHlvXI",
        description: nil,
        stripe_discount: nil,
        due_date: nil,
        forgiven: false,
        next_payment_attempt: nil,
        number: "a04598880b-0014",
        paid: true
      )
      expect(created_invoice.amount_due.format).to eq "100.00 kr."
      expect(created_invoice.amount_paid.format).to eq "100.00 kr."
      expect(created_invoice.amount_remaining.format).to eq "0.00 kr."
      expect(created_invoice.created).to eq Time.zone.parse("2018-02-04 18:29:07")
      expect(created_invoice.period_end).to eq Time.zone.parse("2018-02-04 18:29:07")
      expect(created_invoice.period_start).to eq Time.zone.parse("2018-02-04 18:29:07")
      expect(created_invoice.receipt_number).to be_nil
      expect(created_invoice.starting_balance).to eq 0
      expect(created_invoice.statement_descriptor).to be_nil
      expect(created_invoice.stripe_subscription_id).to eq "sub_CGP2EtRzfVystw"
      expect(created_invoice.subtotal.format).to eq "100.00 kr."
      expect(created_invoice.tax).to be_nil
      expect(created_invoice.tax_percent).to be_nil
      expect(created_invoice.total.format).to eq "100.00 kr."
      expect(created_invoice.invoice_pdf).to eq "https://pay.stripe.com/invoice/XX/invst_YY/pdf"
      expect(created_invoice.hosted_invoice_url).to eq "https://pay.stripe.com/invoice/XX/invst_YY"
      # VERSION 2019-05-16
      expect(created_invoice.auto_advance).to be false
      expect(created_invoice.billing_reason).to eq "subscription_create"
      expect(created_invoice.status).to eq "draft"
      # VERSION 2019-05-16 - status_transitions
      expect(created_invoice.finalized_at).to eq Time.zone.parse("2019-06-29 11:05:35")
      expect(created_invoice.marked_uncollectible_at).to be_nil
      expect(created_invoice.paid_at).to eq Time.zone.parse("2019-06-29 11:05:37")
      expect(created_invoice.voided_at).to be_nil
    end
  end
end

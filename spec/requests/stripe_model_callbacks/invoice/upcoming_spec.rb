require "rails_helper"

describe "invoice upcoming" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_CGNFgjPGtHlvXI" }
  let!(:stripe_invoice) { create :stripe_invoice, id: "in_00000000000000" }

  describe "#execute!" do
    xit "updates the invoice and adds a log" do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.upcoming") } }
        .to change(StripeInvoice, :count).by(0)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.upcoming"), :count).by(1)

      created_invoice = StripeInvoice.last

      expect(response.code).to eq "200"

      expect(created_invoice.id).to eq "in_00000000000000"
      expect(created_invoice.application_fee).to eq nil
      expect(created_invoice.attempt_count).to eq 1
      expect(created_invoice.attempted?).to eq true
      expect(created_invoice.billing).to eq "charge_automatically"
      expect(created_invoice.stripe_charge_id).to eq "ch_00000000000000"
      expect(created_invoice.closed?).to eq true
      expect(created_invoice.currency).to eq "dkk"
      expect(created_invoice.stripe_customer_id).to eq "cus_00000000000000"
      expect(created_invoice.date).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(created_invoice.description).to eq nil
      expect(created_invoice.discount).to eq nil
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
    end
  end
end

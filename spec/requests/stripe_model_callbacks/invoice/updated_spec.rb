require "rails_helper"

describe "invoice updated" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }
  let!(:stripe_invoice) { create :stripe_invoice, stripe_id: "in_00000000000000" }
  let!(:stripe_invoice_item) do
    create :stripe_invoice_item,
      stripe_id: "sub_CHS7NOE0WD1Jro",
      stripe_invoice: stripe_invoice,
      stripe_plan: stripe_plan,
      stripe_subscription_item: stripe_subscription_item
  end
  let!(:stripe_plan) { create :stripe_plan, stripe_id: "peak_flow_build" }
  let!(:stripe_subscription_item) { create :stripe_subscription_item, stripe_id: "si_CHS7VAL80FwJv7" }

  describe "#execute!" do
    it "updates the given invoice" do
      expect { PublicActivity.with_tracking { mock_stripe_event("invoice.updated") } }
        .to change(StripeInvoice, :count).by(0)
        .and change(StripeInvoiceItem, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.update"), :count).by(1)

      stripe_invoice.reload
      stripe_invoice_item.reload

      expect(response.code).to eq "200"

      expect(stripe_invoice).to have_attributes(
        stripe_id: "in_00000000000000",
        application_fee_amount: nil,
        attempt_count: 1,
        attempted: true,
        billing: "charge_automatically",
        stripe_charge_id: "ch_00000000000000",
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
        statement_descriptor: nil,
        stripe_subscription_id: "sub_00000000000000",
        subtotal: Money.new(35_00, "DKK"),
        tax: nil,
        tax_percent: nil,
        total: Money.new(35_00, "DKK")
      )
      expect(stripe_invoice_item.stripe_subscription_item_id).to eq "si_CHS7VAL80FwJv7"
      expect(stripe_invoice_item.stripe_subscription_item).to eq stripe_subscription_item
    end
  end
end

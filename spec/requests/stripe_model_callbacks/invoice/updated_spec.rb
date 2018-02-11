require "rails_helper"

describe "invoice updated" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_CGNFgjPGtHlvXI" }
  let!(:stripe_invoice) { create :stripe_invoice, id: "in_00000000000000" }
  let!(:stripe_invoice_item) do
    create :stripe_invoice_item,
      id: "sub_CHS7NOE0WD1Jro",
      stripe_invoice: stripe_invoice,
      stripe_plan: stripe_plan,
      stripe_subscription_item: stripe_subscription_item
  end
  let!(:stripe_plan) { create :stripe_plan, id: "peak_flow_build" }
  let!(:stripe_subscription_item) { create :stripe_subscription_item, id: "si_CHS7VAL80FwJv7" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/invoice/invoice.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeInvoice, :count).by(0)
        .and change(StripeInvoiceItem, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.update"), :count).by(1)

      stripe_invoice.reload
      stripe_invoice_item.reload

      expect(response.code).to eq "200"

      expect(stripe_invoice.id).to eq "in_00000000000000"
      expect(stripe_invoice.application_fee).to eq nil
      expect(stripe_invoice.attempt_count).to eq 1
      expect(stripe_invoice.attempted?).to eq true
      expect(stripe_invoice.billing).to eq "charge_automatically"
      expect(stripe_invoice.stripe_charge_id).to eq "ch_00000000000000"
      expect(stripe_invoice.closed?).to eq true
      expect(stripe_invoice.currency).to eq "dkk"
      expect(stripe_invoice.stripe_customer_id).to eq "cus_00000000000000"
      expect(stripe_invoice.date).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(stripe_invoice.description).to eq nil
      expect(stripe_invoice.discount).to eq nil
      expect(stripe_invoice.due_date).to eq nil
      expect(stripe_invoice.forgiven?).to eq false
      expect(stripe_invoice.next_payment_attempt).to eq nil
      expect(stripe_invoice.number).to eq "a04598880b-0007"
      expect(stripe_invoice.paid?).to eq true
      expect(stripe_invoice.period_end).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(stripe_invoice.period_start).to eq Time.zone.parse("2018-02-04 17:02:25")
      expect(stripe_invoice.receipt_number).to eq nil
      expect(stripe_invoice.starting_balance).to eq 0
      expect(stripe_invoice.statement_descriptor).to eq nil
      expect(stripe_invoice.stripe_subscription_id).to eq "sub_00000000000000"
      expect(stripe_invoice.subtotal.format).to eq "35.00 kr."
      expect(stripe_invoice.tax).to eq nil
      expect(stripe_invoice.tax_percent).to eq nil
      expect(stripe_invoice.total.format).to eq "35.00 kr."

      expect(stripe_invoice_item.stripe_subscription_item_id).to eq "si_CHS7VAL80FwJv7"
      expect(stripe_invoice_item.stripe_subscription_item).to eq stripe_subscription_item
    end
  end
end

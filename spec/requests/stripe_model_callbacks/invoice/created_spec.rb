require "rails_helper"

describe "invoice created" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_CGNFgjPGtHlvXI" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/invoice/invoice.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeInvoice, :count).by(1)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.create"), :count).by(1)

      created_invoice = StripeInvoice.last

      expect(response.code).to eq "200"

      expect(created_invoice.id).to eq "in_00000000000000"
      expect(created_invoice.application_fee).to eq nil
      expect(created_invoice.attempt_count).to eq 1
      expect(created_invoice.attempted?).to eq false
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
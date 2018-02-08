require "rails_helper"

describe "invoice payment failed" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:stripe_invoice) { create :stripe_invoice, id: "in_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/invoice/invoice.payment_failed.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeInvoice, :count).by(0)
        .and change(StripeInvoiceItem, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_invoice.payment_failed"), :count).by(1)

      stripe_invoice.reload

      expect(response.code).to eq "200"

      expect(stripe_invoice.id).to eq "in_00000000000000"
      expect(stripe_invoice.application_fee).to eq nil
      expect(stripe_invoice.attempt_count).to eq 0
      expect(stripe_invoice.attempted?).to eq true
      expect(stripe_invoice.billing).to eq "charge_automatically"
      expect(stripe_invoice.stripe_charge_id).to eq nil
      expect(stripe_invoice.closed?).to eq false
      expect(stripe_invoice.currency).to eq "usd"
      expect(stripe_invoice.stripe_customer_id).to eq "cus_00000000000000"
      expect(stripe_invoice.stripe_customer).to eq stripe_customer
      expect(stripe_invoice.date).to eq Time.zone.parse("2018-02-05 16:16:02")
      expect(stripe_invoice.description).to eq nil
      expect(stripe_invoice.discount).to eq nil
      expect(stripe_invoice.due_date).to eq nil
      expect(stripe_invoice.forgiven?).to eq false
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
    end
  end
end

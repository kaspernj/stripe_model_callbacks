require "rails_helper"

describe StripeModelCallbacks::Invoice::PaymentSucceededService do
  let!(:stripe_customer) { create :stripe_customer, identifier: "cus_CGNFgjPGtHlvXI" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/invoice_payment_succeeded.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeModelCallbacks::StripeInvoice, :count).by(1)
        .and change(StripeModelCallbacks::StripeInvoiceItem, :count).by(1)

      expect(response.code).to eq "200"
    end
  end
end

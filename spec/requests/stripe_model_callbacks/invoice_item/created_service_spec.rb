require "rails_helper"

describe StripeModelCallbacks::Customer::Subscription::CreatedService do
  let!(:stripe_account) { create :stripe_account, stripe_customer_identifier: "cus_00000000000000" }
  let!(:stripe_invoice) { create :stripe_invoice, stripe_identifier: "silver-express-898_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read(Rails.root.join("spec", "fixtures", "stripe_events", "invoiceitem_created.json")) }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(InvoiceLine, :count).by(1)

      created_invoice_item = InvoiceLine.last

      expect(response.code).to eq "200"
      expect(created_invoice_item.invoice).to eq invoice
      expect(created_invoice_item.price.to_f).to eq "123 kr."
    end
  end
end

require "rails_helper"

describe StripeModelCallbacks::Customer::Subscription::CreatedService do
  let!(:customer) { create :stripe_customer, identifier: "cus_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/invoiceitem_created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeModelCallbacks::StripeInvoiceItem, :count).by(1)

      created_invoice_item = StripeModelCallbacks::StripeInvoiceItem.last

      expect(response.code).to eq "200"
      expect(created_invoice_item.customer).to eq customer
      expect(created_invoice_item.description).to eq "My First Invoice Item (created for API docs)"
      expect(created_invoice_item.discountable).to eq true
      expect(created_invoice_item.invoice).to eq nil
      expect(created_invoice_item.amount.format).to eq "$10.00"
      expect(created_invoice_item.livemode).to eq false
      expect(created_invoice_item.period_start).to eq Time.new(2018, 2, 4, 19, 31, 56)
      expect(created_invoice_item.period_end).to eq Time.new(2018, 2, 4, 19, 31, 56)
      expect(created_invoice_item.plan).to eq nil
    end
  end
end

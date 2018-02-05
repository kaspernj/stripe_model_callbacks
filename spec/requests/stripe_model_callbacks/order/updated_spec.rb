require "rails_helper"

describe "order updated" do
  let!(:order) { create :stripe_order, identifier: "or_00000000000000" }
  let!(:order_item) { create :stripe_order_item, order: order, parent_identifier: "sk_1BrqWPAT5SYrvIfdCfVmF7Kx" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/order_updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeModelCallbacks::StripeOrder, :count).by(0)
        .and change(StripeModelCallbacks::StripeOrderItem, :count).by(0)

      order.reload
      order_item.reload

      expect(response.code).to eq "200"

      expect(order.identifier).to eq "or_00000000000000"
      expect(order.amount.format).to eq "$15.00"
      expect(order.amount_returned).to eq nil
      expect(order.application).to eq nil
      expect(order.application_fee).to eq nil
      expect(order.charge).to eq nil
      expect(order.created_at).to eq Time.new(2018, 2, 5, 14, 12, 19)
      expect(order.customer).to eq nil
      expect(order.email).to eq nil
      expect(order.livemode).to eq false
      expect(order.metadata).to eq "{}"
      expect(order.shipping_address_city).to eq "Anytown"
      expect(order.shipping_address_country).to eq "US"
      expect(order.shipping_address_line1).to eq "1234 Main street"
      expect(order.shipping_address_line2).to eq nil
      expect(order.shipping_address_postal_code).to eq "123456"
      expect(order.shipping_address_state).to eq nil
      expect(order.shipping_carrier).to eq nil
      expect(order.shipping_name).to eq "Jenny Rosen"
      expect(order.shipping_phone).to eq nil
      expect(order.shipping_tracking_number).to eq nil
      expect(order.shipping_methods).to eq nil
      expect(order.status).to eq "created"
      expect(order.updated_at).to eq Time.new(2018, 2, 5, 14, 12, 19)

      expect(order_item.amount.format).to eq "$15.00"
      expect(order_item.currency).to eq "usd"
      expect(order_item.order).to eq order
      expect(order_item.description).to eq "T-shirt"
      expect(order_item.parent_identifier).to eq "sk_1BrqWPAT5SYrvIfdCfVmF7Kx"
      expect(order_item.quantity).to eq nil
      expect(order_item.order_item_type).to eq "sku"
    end
  end
end

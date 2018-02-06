require "rails_helper"

describe "order creation" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/order/order.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeOrder, :count).by(1)
        .and change(StripeOrderItem, :count).by(1)

      created_order = StripeOrder.last
      created_order_item = StripeOrderItem.last

      expect(response.code).to eq "200"

      expect(created_order.id).to eq "or_00000000000000"
      expect(created_order.amount.format).to eq "$15.00"
      expect(created_order.amount_returned).to eq nil
      expect(created_order.application).to eq nil
      expect(created_order.application_fee).to eq nil
      expect(created_order.stripe_charge).to eq nil
      expect(created_order.created).to eq Time.zone.parse("2018-02-05 13:32:13")
      expect(created_order.customer).to eq nil
      expect(created_order.email).to eq nil
      expect(created_order.livemode).to eq false
      expect(created_order.metadata).to eq "{}"
      expect(created_order.shipping_address_city).to eq "Anytown"
      expect(created_order.shipping_address_country).to eq "US"
      expect(created_order.shipping_address_line1).to eq "1234 Main street"
      expect(created_order.shipping_address_line2).to eq nil
      expect(created_order.shipping_address_postal_code).to eq "123456"
      expect(created_order.shipping_address_state).to eq nil
      expect(created_order.shipping_carrier).to eq nil
      expect(created_order.shipping_name).to eq "Jenny Rosen"
      expect(created_order.shipping_phone).to eq nil
      expect(created_order.shipping_tracking_number).to eq nil
      expect(created_order.shipping_methods).to eq nil
      expect(created_order.status).to eq "created"
      expect(created_order.updated).to eq Time.zone.parse("2018-02-05 13:32:13")

      expect(created_order_item.amount.format).to eq "$15.00"
      expect(created_order_item.currency).to eq "usd"
      expect(created_order_item.order).to eq created_order
      expect(created_order_item.description).to eq "T-shirt"
      expect(created_order_item.parent_id).to eq "sk_1BrqWPAT5SYrvIfdCfVmF7Kx"
      expect(created_order_item.quantity).to eq nil
      expect(created_order_item.order_item_type).to eq "sku"
    end
  end
end

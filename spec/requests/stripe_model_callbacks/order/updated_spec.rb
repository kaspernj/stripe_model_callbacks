require "rails_helper"

describe "order updated" do
  let!(:order) { create :stripe_order, stripe_id: "or_00000000000000" }
  let!(:order_item) { create :stripe_order_item, stripe_order: order, parent_id: "sk_1BrqWPAT5SYrvIfdCfVmF7Kx" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { mock_stripe_event("order.updated") }
        .to change(StripeOrder, :count).by(0)
        .and change(StripeOrderItem, :count).by(0)

      order.reload
      order_item.reload

      expect(response.code).to eq "200"

      expect(order.stripe_id).to eq "or_00000000000000"
      expect(order.amount.format).to eq "$15.00"
      expect(order.amount_returned).to be_nil
      expect(order.application).to be_nil
      expect(order.application_fee).to be_nil
      expect(order.stripe_charge).to be_nil
      expect(order.created).to eq Time.zone.parse("2018-02-05 14:12:19")
      expect(order.stripe_customer).to be_nil
      expect(order.email).to be_nil
      expect(order.livemode).to be false
      expect(order.metadata).to eq "{}"
      expect(order.shipping_address_city).to eq "Anytown"
      expect(order.shipping_address_country).to eq "US"
      expect(order.shipping_address_line1).to eq "1234 Main street"
      expect(order.shipping_address_line2).to be_nil
      expect(order.shipping_address_postal_code).to eq "123456"
      expect(order.shipping_address_state).to be_nil
      expect(order.shipping_carrier).to be_nil
      expect(order.shipping_name).to eq "Jenny Rosen"
      expect(order.shipping_phone).to be_nil
      expect(order.shipping_tracking_number).to be_nil
      expect(order.shipping_methods).to be_nil
      expect(order.status).to eq "created"
      expect(order.updated).to eq Time.zone.parse("2018-02-05 14:12:19")

      expect(order_item.amount.format).to eq "$15.00"
      expect(order_item.currency).to eq "usd"
      expect(order_item.stripe_order).to eq order
      expect(order_item.description).to eq "T-shirt"
      expect(order_item.parent_id).to eq "sk_1BrqWPAT5SYrvIfdCfVmF7Kx"
      expect(order_item.quantity).to be_nil
      expect(order_item.order_item_type).to eq "sku"
    end
  end
end

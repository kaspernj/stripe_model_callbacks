require "rails_helper"

describe "order creation" do
  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { mock_stripe_event("order.created") }
        .to change(StripeOrder, :count).by(1)
        .and change(StripeOrderItem, :count).by(1)

      created_order = StripeOrder.last
      created_order_item = StripeOrderItem.last

      expect(response.code).to eq "200"

      expect(created_order.stripe_id).to eq "or_00000000000000"
      expect(created_order.amount.format).to eq "$15.00"
      expect(created_order.amount_returned).to be_nil
      expect(created_order.application).to be_nil
      expect(created_order.application_fee).to be_nil
      expect(created_order.stripe_charge).to be_nil
      expect(created_order.created).to eq Time.zone.parse("2018-02-05 13:32:13")
      expect(created_order.stripe_customer).to be_nil
      expect(created_order.email).to be_nil
      expect(created_order.livemode).to be false
      expect(created_order.metadata).to eq "{}"
      expect(created_order.shipping_address_city).to eq "Anytown"
      expect(created_order.shipping_address_country).to eq "US"
      expect(created_order.shipping_address_line1).to eq "1234 Main street"
      expect(created_order.shipping_address_line2).to be_nil
      expect(created_order.shipping_address_postal_code).to eq "123456"
      expect(created_order.shipping_address_state).to be_nil
      expect(created_order.shipping_carrier).to be_nil
      expect(created_order.shipping_name).to eq "Jenny Rosen"
      expect(created_order.shipping_phone).to be_nil
      expect(created_order.shipping_tracking_number).to be_nil
      expect(created_order.shipping_methods).to be_nil
      expect(created_order.status).to eq "created"
      expect(created_order.updated).to eq Time.zone.parse("2018-02-05 13:32:13")

      expect(created_order_item.amount.format).to eq "$15.00"
      expect(created_order_item.currency).to eq "usd"
      expect(created_order_item.stripe_order).to eq created_order
      expect(created_order_item.description).to eq "T-shirt"
      expect(created_order_item.parent_id).to eq "sk_1BrqWPAT5SYrvIfdCfVmF7Kx"
      expect(created_order_item.quantity).to be_nil
      expect(created_order_item.order_item_type).to eq "sku"
    end
  end
end

require "rails_helper"

describe "sku created" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/sku/sku.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeSku, :count).by(1)

      created_sku = StripeSku.last

      expect(response.code).to eq "200"

      expect(created_sku.identifier).to eq "sku_00000000000000"
      expect(created_sku.inventory_quantity).to eq 50
      expect(created_sku.inventory_type).to eq "finite"
      expect(created_sku.inventory_value).to eq nil
      expect(created_sku.livemode).to eq false
      expect(created_sku.metadata).to eq "{}"
      expect(created_sku.price.format).to eq "$15.00"
      expect(created_sku.product_identifier).to eq "prod_00000000000000"
    end
  end
end

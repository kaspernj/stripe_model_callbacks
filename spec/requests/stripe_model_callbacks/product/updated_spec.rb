require "rails_helper"

describe "product updated" do
  let!(:product) { create :stripe_product, identifier: "prod_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/product/product.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeProduct, :count).by(0)

      product.reload

      expect(response.code).to eq "200"

      expect(product.identifier).to eq "prod_00000000000000"
      expect(product.active?).to eq false
      expect(product.created).to eq Time.zone.parse("2018-02-04 16:49:05")
      expect(product.updated).to eq Time.zone.parse("2018-02-04 16:49:05")
      expect(product.name).to eq "Extra Large"
    end
  end
end

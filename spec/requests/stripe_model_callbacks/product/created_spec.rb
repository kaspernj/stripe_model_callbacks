require "rails_helper"

describe "product created" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/product/product.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeProduct, :count).by(1)

      created_product = StripeProduct.last

      expect(response.code).to eq "200"

      expect(created_product.identifier).to eq "prod_00000000000000"
    end
  end
end

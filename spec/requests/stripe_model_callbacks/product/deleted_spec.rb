require "rails_helper"

describe "product deleted" do
  let!(:product) { create :stripe_product, identifier: "prod_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/product_deleted.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeModelCallbacks::StripeProduct, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_model_callbacks_stripe_product.deleted"), :count).by(1)

      product.reload

      expect(response.code).to eq "200"

      expect(product.identifier).to eq "prod_00000000000000"
      expect(product.active?).to eq false
      expect(product.created_at).to eq Time.zone.parse("2018-02-04 16:49:05")
      expect(product.updated_at).to eq Time.zone.parse("2018-02-04 16:49:05")
      expect(product.name).to eq "Extra Large"
      expect(product.deleted_at).to be > 1.minute.ago
    end
  end
end

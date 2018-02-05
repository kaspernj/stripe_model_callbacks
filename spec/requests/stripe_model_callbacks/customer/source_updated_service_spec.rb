require "rails_helper"

describe StripeModelCallbacks::Customer::SourceUpdatedService do
  let!(:stripe_account) { create :stripe_account, stripe_customer_identifier: "cus_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read(Rails.root.join("spec", "fixtures", "stripe_events", "customer_source_updated.json")) }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      post "/stripe-events", params: payload

      account.reload

      expect(response.code).to eq "200"
      expect(account.stripe_invoice_prefix).to eq "c41d443e39"
    end
  end
end

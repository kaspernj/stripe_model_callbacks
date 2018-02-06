require "rails_helper"

describe "customer creation" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeCustomer, :count).by(1)

      created_customer = StripeCustomer.last

      expect(response.code).to eq "200"
      expect(created_customer.identifier).to eq "cus_2wm5EgmRGEiyPO"
      expect(created_customer.livemode).to eq false
      expect(created_customer.description).to eq "id:12345"
      expect(created_customer.delinquent).to eq false
      expect(created_customer.metadata).to eq "{}"
      expect(created_customer.email).to eq "user@example.com"
      expect(created_customer.subscription).to eq nil
      expect(created_customer.discount).to eq nil
      expect(created_customer.account_balance).to eq 0
    end
  end
end

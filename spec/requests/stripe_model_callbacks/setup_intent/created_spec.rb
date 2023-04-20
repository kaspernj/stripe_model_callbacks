require "rails_helper"

describe "setup intent created" do
  let(:stripe_customer) { create :stripe_customer, stripe_id: "cus_NKCaPfiHnRAtaq" }

  describe "#execute!" do
    it "marks the charge as intented" do
      stripe_customer

      expect { PublicActivity.with_tracking { mock_stripe_event("setup_intent.created") } }
        .to change(PublicActivity::Activity.where(key: "stripe_setup_intent.create"), :count).by(1)
        .and change(StripeSetupIntent, :count).by(1)

      created_setup_intent = StripeSetupIntent.order(:created_at).last!

      expect(response).to have_http_status :ok

      expect(created_setup_intent).to have_attributes(
        stripe_id: "seti_1MZYBJIICJxvfdbRFtP2AeIi",
        application: nil,
        cancellation_reason: nil,
        client_secret: "seti_1MZYBJIICJxvfdbRFtP2AeIi_secret_NKCapEVr1rCGRLrEjdHGercMNLWCKkH",
        created: Time.zone.parse("2023-02-09 11:20:49"),
        customer: "cus_NKCaPfiHnRAtaq",
        description: nil,
        flow_directions: nil,
        last_setup_error: nil,
        latest_attempt: nil,
        livemode: false,
        mandate: nil,
        metadata: "{}",
        next_action: nil,
        on_behalf_of: nil,
        payment_method: nil,
        payment_method_options: {
          "card" => {
            "mandate_options" => nil,
            "network" => nil,
            "request_three_d_secure" => "automatic"
          }
        },
        payment_method_types: [
          "card"
        ],
        single_use_mandate: nil,
        status: "requires_payment_method",
        usage: "off_session",
        stripe_customer: stripe_customer
      )
      expect(stripe_customer.stripe_setup_intents).to eq [created_setup_intent]
    end
  end
end

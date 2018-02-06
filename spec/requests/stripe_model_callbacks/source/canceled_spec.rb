require "rails_helper"

describe "source canceled" do
  let!(:source) { create :stripe_source, identifier: "src_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/source/source.canceled.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates an activity and updates the source" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeSource, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_source.canceled"), :count).by(1)

      source.reload

      expect(response.code).to eq "200"

      expect(source.currency).to eq "usd"
      expect(source.identifier).to eq "src_00000000000000"
      expect(source.flow).to eq "receiver"
      expect(source.created).to eq Time.zone.parse("2018-02-06 07:41:46")
      expect(source.livemode).to eq false
      expect(source.client_secret).to eq "src_client_secret_CGz38yIZuPGBR0ytLA9HdqqJ"
      expect(source.owner_email).to eq "jenny.rosen@example.com"
      expect(source.receiver_address).to eq "121042882-38381234567890123"
      expect(source.receiver_refund_attributes_method).to eq "email"
      expect(source.receiver_refund_attributes_status).to eq "missing"
      expect(source.status).to eq "pending"
      expect(source.stripe_type).to eq "ach_credit_transfer"
      expect(source.ach_credit_transfer_account_number).to eq "test_52796e3294dc"
      expect(source.ach_credit_transfer_routing_number).to eq "110000000"
      expect(source.ach_credit_transfer_fingerprint).to eq "ecpwEzmBOSMOqQTL"
      expect(source.ach_credit_transfer_bank_name).to eq "TEST BANK"
      expect(source.ach_credit_transfer_swift_code).to eq "TSTEZ122"
    end
  end
end

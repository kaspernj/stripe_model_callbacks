require "rails_helper"

describe "source chargeable" do
  let!(:source) { create :stripe_source, stripe_id: "src_00000000000000" }

  describe "#execute!" do
    it "creates an activity and updates the source" do
      expect { mock_stripe_event("source.chargeable") }
        .to change(StripeSource, :count).by(0)
        .and change(ActiveRecordAuditable::Audit.where_type("StripeSource").where_action("chargeable"), :count).by(1)

      source.reload

      expect(response).to have_http_status :ok

      expect(source.currency).to eq "usd"
      expect(source.stripe_id).to eq "src_00000000000000"
      expect(source.flow).to eq "receiver"
      expect(source.created).to eq Time.zone.parse("2018-02-06 08:41:50")
      expect(source.livemode).to be false
      expect(source.client_secret).to eq "src_client_secret_CH01F485RhmrXTuK10ExxZVs"
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

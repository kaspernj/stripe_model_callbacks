require "rails_helper"

describe "charge refunded" do
  let!(:charge) do
    StripeCharge.find_or_create_by!(stripe_id: "ch_00000000000000") do |record|
      record.amount = Money.new(100, "USD")
      record.captured = false
      record.currency = "usd"
      record.livemode = false
      record.paid = false
      record.refunded = false
    end
  end

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { mock_stripe_event("charge.refunded") }
        .to change(ActiveRecordAuditable::Audit.where_type("StripeCharge").where_action("refunded"), :count).by(1)
        .and change(StripeCharge, :count).by(0)
        .and change(StripeRefund, :count).by(0)

      charge.reload

      expect(response).to have_http_status :ok

      expect(charge.amount.format).to eq "$1.00"
      expect(charge.amount_captured.format).to eq "$1.00"
      expect(charge.amount_refunded.format).to eq "$1.00"
      expect(charge).to have_attributes(
        description: "My First Test Charge (created for API docs)",
        refunded: true
      )
    end
  end
end

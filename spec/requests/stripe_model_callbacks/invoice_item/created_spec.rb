require "rails_helper"

describe "subscription creation" do
  let!(:customer) { create :stripe_customer, id: "cus_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("invoiceitem.created") }
        .to change(StripeInvoiceItem, :count).by(1)

      created_invoice_item = StripeInvoiceItem.last

      expect(response.code).to eq "200"
      expect(created_invoice_item.stripe_customer).to eq customer
      expect(created_invoice_item.description).to eq "My First Invoice Item (created for API docs)"
      expect(created_invoice_item.discountable).to eq true
      expect(created_invoice_item.stripe_invoice).to eq nil
      expect(created_invoice_item.amount.format).to eq "$10.00"
      expect(created_invoice_item.livemode).to eq false
      expect(created_invoice_item.period_start).to eq Time.zone.parse("2018-02-04 19:31:56")
      expect(created_invoice_item.period_end).to eq Time.zone.parse("2018-02-04 19:31:56")
      expect(created_invoice_item.stripe_plan).to eq nil
    end
  end
end

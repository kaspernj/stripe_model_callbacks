require "rails_helper"

describe StripeModelCallbacks::SyncEverything do
  it "calls all the sync-all services" do
    expect(StripeModelCallbacks::Coupon::SyncAll).to receive(:execute!)
    expect(StripeModelCallbacks::Plan::SyncAll).to receive(:execute!)

    StripeModelCallbacks::SyncEverything.execute!
  end
end

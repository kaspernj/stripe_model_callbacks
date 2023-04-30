require "rails_helper"

describe StripeModelCallbacks::SyncEverything do
  it "calls all the sync-all services" do
    StripeModelCallbacks::SyncEverything.stripe_classes.each do |stripe_class| # rubocop:disable RSpec/IteratedExpectation
      expect(stripe_class).to receive(:list).and_return([])
    end

    StripeModelCallbacks::SyncEverything.execute!
  end
end

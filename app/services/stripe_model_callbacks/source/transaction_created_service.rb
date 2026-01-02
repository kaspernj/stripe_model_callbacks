class StripeModelCallbacks::Source::TransactionCreatedService < StripeModelCallbacks::BaseEventService
  def perform
    return succeed! unless source

    source.create_audit!(action: :transaction_created)
    succeed!
  end

private

  def source
    @source ||= begin
      source_id = object.respond_to?(:source) ? object.source : nil
      source_id ? StripeSource.find_by(stripe_id: source_id) : nil
    end
  end
end

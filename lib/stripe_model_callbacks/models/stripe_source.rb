class StripeSource < StripeModelCallbacks::ApplicationRecord
  monetize :amount_cents, allow_nil: true
  monetize :receiver_amount_charged_cents, allow_nil: true
  monetize :receiver_amount_received_cents, allow_nil: true
  monetize :receiver_amount_returned_cents, allow_nil: true

  def self.stripe_class
    Stripe::Source
  end

  def assign_from_stripe(object)
    self.stripe_type = object.type
    self.amount = Money.new(object.amount, object.currency) if object.respond_to?(:amount)

    assign_owner(object)
    assign_owner_verified(object)
    assign_receiver(object)
    assign_ach_credit_transfer(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        client_secret created currency flow livemode metadata statement_descriptor
        status usage
      ]
    )
  end

private

  def assign_owner(object) # rubocop:disable Metrics/AbcSize
    assign_attributes(
      owner_address_city: object.owner.address&.city,
      owner_address_country: object.owner.address&.country,
      owner_address_line1: object.owner.address&.line1,
      owner_address_line2: object.owner.address&.line2,
      owner_address_postal_code: object.owner.address&.postal_code,
      owner_address_state: object.owner.address&.state,
      owner_email: object.owner.email,
      owner_name: object.owner.name,
      owner_phone: object.owner.phone
    )
  end

  def assign_owner_verified(object) # rubocop:disable Metrics/AbcSize
    assign_attributes(
      owner_verified_address_city: object.owner.verified_address&.city,
      owner_verified_address_country: object.owner.verified_address&.country,
      owner_verified_address_line1: object.owner.verified_address&.line1,
      owner_verified_address_line2: object.owner.verified_address&.line2,
      owner_verified_address_postal_code: object.owner.verified_address&.postal_code,
      owner_verified_address_state: object.owner.verified_address&.state,
      owner_verified_email: object.owner.verified_email,
      owner_verified_name: object.owner.verified_name,
      owner_verified_phone: object.owner.verified_phone
    )
  end

  def assign_receiver(object)
    assign_attributes(
      receiver_address: object.receiver.address,
      receiver_amount_charged: Money.new(object.receiver.amount_charged, object.currency),
      receiver_amount_received: Money.new(object.receiver.amount_received, object.currency),
      receiver_amount_returned: Money.new(object.receiver.amount_returned, object.currency),
      receiver_refund_attributes_method: object.receiver.refund_attributes_method,
      receiver_refund_attributes_status: object.receiver.refund_attributes_status
    )
  end

  def assign_ach_credit_transfer(object)
    assign_attributes(
      ach_credit_transfer_account_number: object.ach_credit_transfer.account_number,
      ach_credit_transfer_routing_number: object.ach_credit_transfer.routing_number,
      ach_credit_transfer_fingerprint: object.ach_credit_transfer.fingerprint,
      ach_credit_transfer_bank_name: object.ach_credit_transfer.bank_name,
      ach_credit_transfer_swift_code: object.ach_credit_transfer.swift_code
    )
  end
end

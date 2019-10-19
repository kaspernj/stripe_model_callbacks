class StripeModelCallbacks::ApplicationRecord < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  self.abstract_class = true

  attr_writer :stripe_object

  def self.create_from_stripe!(object)
    model = new
    model.stripe_object = object
    model.assign_from_stripe(object)
    model.save!
    model
  end

  def self.create_on_stripe!(attributes)
    object = stripe_class.create(attributes)
    create_from_stripe!(object)
  end

  def to_stripe
    @to_stripe ||= self.class.stripe_class.retrieve(stripe_id)
  end

  def reload_from_stripe!
    assign_from_stripe(to_stripe)
    save!
  end

  def reload!(*args, &blk)
    @to_stripe = nil
    super
  end

  def update_on_stripe(attributes)
    attributes.each do |key, value|
      to_stripe.__send__("#{key}=", value)
    end

    to_stripe.save
    reload_from_stripe!
    true
  end

  def update_on_stripe!(attributes)
    raise ActiveRecord::RecordInvalid, self unless update_on_stripe(attributes)
  end

  def destroy_on_stripe
    to_stripe.delete
    update!(deleted_at: Time.zone.now) if respond_to?(:deleted_at)
    reload_from_stripe!
    true
  end

  def destroy_on_stripe!
    raise ActiveRecord::RecordInvalid, self unless destroy_on_stripe
  end
end

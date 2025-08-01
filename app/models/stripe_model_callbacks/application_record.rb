class StripeModelCallbacks::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :stripe_object

  def self.inherited(child)
    super
    child.include ActiveRecordAuditable::Audited
  end

  def self.check_object_is_stripe_class(object, allowed = nil)
    raise "'stripe_class' not defined on #{name}" unless respond_to?(:stripe_class)

    # Ignore general objects
    return if object.class.name == "Stripe::StripeObject" # rubocop:disable Style/ClassEqualityComparison

    allowed ||= [stripe_class]

    raise "Expected #{object.class.name} to be a #{allowed.map(&:name).join(", ")}" unless allowed.any? { |stripe_class| object.is_a?(stripe_class) }
  end

  def check_object_is_stripe_class(object, allowed = nil)
    self.class.check_object_is_stripe_class(object, allowed)
  end

  def self.create_from_stripe!(object)
    check_object_is_stripe_class(object)

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

  def reload!(*args, &)
    @to_stripe = nil
    super
  end

  def update_on_stripe(attributes) # rubocop:disable Naming/PredicateMethod
    attributes.each do |key, value|
      to_stripe.__send__(:"#{key}=", value)
    end

    to_stripe.save
    reload_from_stripe!
    true
  end

  def update_on_stripe!(attributes)
    raise ActiveRecord::RecordInvalid, self unless update_on_stripe(attributes)
  end

  def destroy_on_stripe # rubocop:disable Naming/PredicateMethod
    raise "Can't delete #{self.class.name} on Stripe because it isn't supported" unless to_stripe.respond_to?(:delete)

    to_stripe.delete
    update!(deleted_at: Time.zone.now) if respond_to?(:deleted_at)
    reload_from_stripe!
    true
  end

  def destroy_on_stripe!
    raise ActiveRecord::RecordInvalid, self unless destroy_on_stripe
  end
end

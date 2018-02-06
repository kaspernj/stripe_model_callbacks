class StripeModelCallbacks::ApplicationRecord < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  self.abstract_class = true

  def self.create_from_stripe!(object)
    model = new
    model.assign_from_stripe(object)
    model.save!
    model
  end

  def to_stripe
    @_to_stripe ||= self.class.stripe_class.retrieve(id)
  end

  def reload_from_stripe!
    assign_from_stripe(to_stripe)
    save!
  end
end

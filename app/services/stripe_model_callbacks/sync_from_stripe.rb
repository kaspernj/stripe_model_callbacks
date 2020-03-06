class StripeModelCallbacks::SyncFromStripe < StripeModelCallbacks::BaseService
  attr_reader :stripe_object

  def initialize(stripe_object:)
    @stripe_object = stripe_object
  end

  def execute
    model = model_class.find_by(stripe_id: stripe_object.id)

    if model
      model.stripe_object = stripe_object
      model.assign_from_stripe(stripe_object)
      model.save! if model.changed?
    else
      model = model_class.create_from_stripe!(stripe_object)
    end

    succeed!(model: model)
  end

  def model_class_name
    @model_class_name ||= stripe_object.class.name.gsub("::", "")
  end

  def model_class
    @model_class ||= model_class_name.safe_constantize
  end
end
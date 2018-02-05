class StripeModelCallbacks::AttributesAssignerService < ServicePattern::Service
  attr_reader :attributes, :model, :stripe_model

  def initialize(attributes:, model:, stripe_model:)
    @attributes = attributes
    @model = model
    @stripe_model = stripe_model
  end

  def execute!
    attributes.each do |attribute|
      setter_method = "#{attribute}="
      value = stripe_model.__send__(attribute)
      model.__send__(setter_method, value)
    end
  end
end

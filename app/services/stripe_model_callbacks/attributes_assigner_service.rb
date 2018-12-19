class StripeModelCallbacks::AttributesAssignerService < ServicePattern::Service
  attr_reader :attributes, :model, :stripe_model

  def initialize(attributes:, model:, stripe_model:)
    @attributes = attributes
    @model = model
    @stripe_model = stripe_model
  end

  def execute!
    attributes.each do |attribute|
      next unless stripe_model.respond_to?(attribute)

      if attribute == "id"
        setter_method = "stripe_id="
      else
        setter_method = "#{attribute}="
      end

      value = stripe_model.__send__(attribute)

      if attribute == "metadata"
        value = JSON.generate(value)
      elsif attribute == "created" && value
        value = Time.zone.at(value)
      end

      model.__send__(setter_method, value)
    end
  end
end

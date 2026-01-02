class StripeModelCallbacks::AttributesAssignerService < ServicePattern::Service
  attr_reader :attributes, :model, :stripe_model

  SKIP_VALUE = Object.new

  def initialize(attributes:, model:, stripe_model:)
    @attributes = attributes
    @model = model
    @stripe_model = stripe_model
  end

  def perform
    attributes.each do |attribute|
      value = value_for_attribute(attribute)
      next if value == SKIP_VALUE

      value = normalize_value(attribute, value)

      model.__send__(setter_method(attribute), value)
    end

    succeed!
  end

  def value_for_attribute(attribute)
    if stripe_model.respond_to?(attribute)
      value = stripe_model.__send__(attribute)
      return default_value_for(attribute) if value.nil?

      return value
    end

    return SKIP_VALUE unless model_value(attribute).nil?

    default_value_for(attribute) || SKIP_VALUE
  end

  def normalize_value(attribute, value)
    if attribute == "metadata"
      JSON.generate(value)
    elsif attribute == "created" && value
      Time.zone.at(value)
    else
      value
    end
  end

  def model_value(attribute)
    model.__send__(column_name_for(attribute))
  end

  def default_value_for(attribute)
    default_value = model.class.column_defaults[column_name_for(attribute)]

    return default_value unless default_value.nil?

    nil
  end

  def column_name_for(attribute)
    attribute == "id" ? "stripe_id" : attribute
  end

  def setter_method(attribute)
    if attribute == "id"
      "stripe_id="
    else
      "#{attribute}="
    end
  end
end

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

      log_livemode_debug(attribute, value)
      value = normalize_value(attribute, value)

      model.__send__(setter_method(attribute), value)
    end

    succeed!
  end

  def value_for_attribute(attribute)
    return value_from_stripe(attribute) if stripe_model.respond_to?(attribute)

    return nil if allow_nil_attribute?(attribute)
    return SKIP_VALUE unless model_value(attribute).nil?

    default_value = default_value_for(attribute)
    return SKIP_VALUE if default_value.nil?

    default_value
  end

  def value_from_stripe(attribute)
    return nil if allow_nil_attribute?(attribute) && stripe_attribute_missing?(attribute)

    value = stripe_model.__send__(attribute)
    return nil if value.nil? && allow_nil_attribute?(attribute)
    return default_value_for(attribute) if value.nil?

    value
  end

  def stripe_attribute_missing?(attribute)
    return false unless stripe_model.respond_to?(:to_hash)

    stripe_values = stripe_model.to_hash
    !stripe_values.key?(attribute.to_sym) && !stripe_values.key?(attribute.to_s)
  end

  def normalize_value(attribute, value)
    if attribute == "created" && value
      Time.zone.at(value)
    elsif json_column?(attribute)
      normalize_json_value(value)
    elsif attribute == "metadata"
      JSON.generate(normalize_json_value(value))
    else
      value
    end
  end

  def log_livemode_debug(attribute, value)
    return unless attribute == "livemode"
    return unless Rails.env.test?

    respond = stripe_model.respond_to?(attribute)
    model_value = model_value(attribute)
    default_value = default_value_for(attribute)
    $stdout.puts(
      "[SMC DEBUG] livemode respond=#{respond} stripe_value=#{value.inspect} " \
      "model_value=#{model_value.inspect} default=#{default_value.inspect} " \
      "model_class=#{model.class.name}"
    )
  end

  def model_value(attribute)
    model.__send__(column_name_for(attribute))
  end

  def default_value_for(attribute)
    default_value = model.class.column_defaults[column_name_for(attribute)]

    return default_value unless default_value.nil?

    nil
  end

  def allow_nil_attribute?(attribute)
    attribute == "auto_advance"
  end

  def json_column?(attribute)
    column = model.class.columns_hash[column_name_for(attribute)]
    column&.type == :json
  end

  def normalize_json_value(value)
    return value if value.nil?

    if value.is_a?(String)
      begin
        return JSON.parse(value)
      rescue JSON::ParserError
        return value
      end
    end

    if value.is_a?(Array)
      value.map { |item| normalize_json_value(item) }
    elsif value.respond_to?(:to_hash)
      value.to_hash
    else
      value
    end
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

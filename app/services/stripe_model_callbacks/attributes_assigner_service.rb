class StripeModelCallbacks::AttributesAssignerService < ServicePattern::Service
  attr_reader :attributes, :model, :stripe_model

  SKIP_VALUE = Object.new
  JSON_COLUMNS_BY_TABLE = {
    "audits" => %w[audited_changes params],
    "stripe_payment_intents" => %w[
      amount_details
      automatic_payment_methods
      last_payment_error
      metadata
      next_action
      payment_method_options
      payment_method_types
      processing
      shipping
      transfer_data
    ],
    "stripe_payment_methods" => %w[billing_details card metadata],
    "stripe_setup_intents" => %w[
      flow_directions
      mandate
      payment_method_old
      payment_method_options
      payment_method_types
    ]
  }.freeze

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

    values = stripe_model.instance_variable_get(:@values)
    return !values.key?(attribute.to_sym) && !values.key?(attribute.to_s) if values.is_a?(Hash)

    stripe_values = stripe_model.to_hash
    !stripe_values.key?(attribute.to_sym) && !stripe_values.key?(attribute.to_s)
  end

  def normalize_value(attribute, value)
    if attribute == "created" && value
      Time.zone.at(value)
    elsif (converted_value = datetime_column_value(attribute, value))
      converted_value
    elsif json_column?(attribute)
      normalize_json_value(value)
    elsif attribute == "metadata"
      JSON.generate(normalize_json_value(value))
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

  def allow_nil_attribute?(attribute)
    attribute == "auto_advance"
  end

  def json_column?(attribute)
    column_name = column_name_for(attribute)
    return true if json_columns_for_table.include?(column_name)

    column = model.class.columns_hash[column_name]
    return false unless column
    return true if column.type == :json

    false
  end

  def json_columns_for_table
    JSON_COLUMNS_BY_TABLE.fetch(model.class.table_name, [])
  end

  def datetime_column_value(attribute, value)
    return false unless value

    column = model.class.columns_hash[column_name_for(attribute)]
    return false unless column&.type == :datetime

    timestamp = numeric_timestamp_value(value)
    return Time.zone.at(timestamp) if timestamp

    value
  end

  def numeric_timestamp_value(value)
    return value.to_i if value.is_a?(Integer) || value.is_a?(Float)

    value.to_i if value.is_a?(String) && value.match?(/\A\d+\z/)
  end

  def normalize_json_value(value)
    return value if value.nil?

    return normalize_json_string(value) if value.is_a?(String)

    return value.map { |item| normalize_json_value(item) } if value.is_a?(Array)

    return value.transform_values { |item| normalize_json_value(item) } if value.is_a?(Hash)

    return normalize_json_value(value.to_hash) if value.respond_to?(:to_hash)

    value
  end

  def normalize_json_string(value)
    sanitized_value = value.tr("\u00A0", " ")
    stripped_value = sanitized_value.strip
    return value unless stripped_value.start_with?("{", "[")

    begin
      parsed_value = JSON.parse(sanitized_value)
      normalize_json_value(parsed_value)
    rescue JSON::ParserError
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

class DecimalValidator < Apipie::Validator::BaseValidator
  def initialize(param_description, _argument, options)
    super(param_description)
    @precision = options.fetch(:precision, 12).to_i
    @scale = options.fetch(:scale, 2).to_i
  end

  def validate(value)
    return false if value.nil?
    value.to_s =~ /^\d{1,#{@precision - @scale}}(\.\d{1,#{@scale}})?$/
  end

  def self.build(param_description, argument, options, _block)
    new(param_description, argument, options) if :decimal == argument
  end

  def description
    "Must be a decimal value with a max precision of #{@precision} and a scale of #{@scale}."
  end
end

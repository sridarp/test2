module ValueTypes
  extend ActiveSupport::Concern

  TYPES = {
    string: 0,
    password: 1,
    integer: 2,
    boolean: 3,
    array: 4,
    json: 5,
    date: 6,
    datetime: 7,
    fingerprint: 8,
    certificate: 9,
    text: 10,
    url: 11,
    email: 12,
    cidr: 13
  }.freeze

  included do
    validates :value, uri: true, if: -> (s) { s.value_type == 'url' }
    validates :value, email: true, if: -> (s) { s.value_type == 'email' }
    validates :value, numericality: { only_integer: true }, if: -> (s) { s.value_type == 'integer' }
    validates :value_type, inclusion: ValueTypes::TYPES.keys.map(&:to_s)

    # TODO: Add more type validations

    enum value_type: ValueTypes::TYPES

    def value
      self[:value].nil? ? nil : YAML.load(self[:value])
    end

    private

    def parse_string_value
      begin
        v = Jellyfish::Cast::String.cast(self[:value], value_type)
        self[:value] = v.to_yaml
      rescue Jellyfish::Cast::FailedCastException => e
        invalid_value_error e.to_s
        return false
      rescue Jellyfish::Cast::UnhandledCastException
        raise StandardError, "parsing settings type '#{value_type}' from string is not defined"
      end
      true
    end

    # Convert/Cast the value to the proper type
    def convert_value
      # Do nothing if value has not changed
      return true unless value_changed?
      # Cast the value and return success
      return parse_string_value if self[:value].is_a? String
      # Convert the value to yaml otherwise
      self[:value] = self[:value].to_yaml unless self[:value].nil?
    end

    def invalid_value_error(error)
      errors.add :value, "is invalid: #{error}"
    end
  end
end

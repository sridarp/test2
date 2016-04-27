class UriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, 'must be a valid URI' unless %w(http https).include? URI(value).scheme
  rescue URI::InvalidURIError, ArgumentError
    record.errors.add attribute, 'must be a valid URI'
  end
end

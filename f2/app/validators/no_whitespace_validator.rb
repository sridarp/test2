class NoWhitespaceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'can\'t contain spaces.') if value =~ /\s/
  end
end

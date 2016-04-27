module DuplicateRecordDetection
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotUnique, with: :duplicate_record_error
  end

  module ClassMethods
  end

  def duplicate_record_error(e)
    # Display the error in the development log
    Rails.logger.warn(e.message) if 'development' == Rails.env
    render json: { error: 'Duplicate record.', details: e.message }, status: 422
  end
end

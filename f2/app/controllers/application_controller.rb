# Default controller
class ApplicationController < ActionController::Base
  respond_to :json

  include Pundit

  # Error Handling
  include InvalidRecordDetection
  include DuplicateRecordDetection
  include UnauthorizedAccessDetection
  include MissingRecordDetection
  include ParameterValidation

  # Response Rending
  include RenderWithParams
  include MethodResolution

  # Querying
  include Pagination
  include AssociationResolution
  include QueryBuilder
  include TagsList

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?, only: [:create, :acs]
  before_action :require_user

  def_param_group :answers do
    param :answers, Array, desc: 'Provisioning Answers', allow_nil: true do
      param :name, String, desc: 'Answer key'
      param :value_type, String, desc: 'How to interpret the :value'
    end
  end

  def self.error_codes
    error code: 404, desc: MissingRecordDetection::Messages.not_found
    error code: 422, desc: ParameterValidation::Messages.missing
  end

  def require_user
    head :unauthorized unless user_signed_in?
  end

  def current_user
    current_staff
  end

  def user_signed_in?
    staff_signed_in?
  end

  def user_session
    staff_session
  end

  # Used by ActiveModelSerializers
  def default_serializer_options
    { root: false }
  end

  private

  def json_request?
    request.format.json?
  end

  def pre_hook
    ActiveSupport::Notifications.instrument(controller_name + '#' + action_name + '/pre_hook', params)
  end

  def post_hook
    ActiveSupport::Notifications.instrument(controller_name + '#' + action_name + '/post_hook', params)
  end

  def fail_with(error: '', type: nil)
    render json: { error: error }.tap { |e| e.merge!(type: type) unless type.nil? }, status: :bad_request
  end
end

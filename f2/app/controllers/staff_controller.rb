class StaffController < ApplicationController
  skip_before_action :require_user, only: :current_member
  before_action :pre_hook
  after_action :post_hook

  has_scope :with_deleted, type: :boolean

  def self.document_staff_params
    param :email, String
    param :first_name, String
    param :last_name, String
    param :role, String
    param :password, String
    param :password_confirmation, String
    error code: 422, desc: ParameterValidation::Messages.missing
  end

  api :GET, '/staff', 'Returns a collection of staff'
  param :includes, Array, in: %w(user_settings projects alerts)
  param :methods, Array, in: %w(allowed)
  param :page, :number
  param :per_page, :number
  param :query, String, desc: 'queries against first name, last name, and email'

  def index
    respond_with_params staffs
  end

  api :GET, '/staff/:id', 'Shows staff member with :id'
  param :id, :number, required: true
  param :includes, Array, in: %w(user_settings projects alerts)
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    respond_with_params staff
  end

  api :GET, '/staff/current_member', 'Shows logged in member'
  param :includes, Array, in: %w(user_settings projects notifications cart groups alerts)
  error code: 401, desc: 'User is not signed in.'

  def current_member
    if current_user
      respond_with_params current_user
    else
      render json: { error: 'No session.' }, status: 401
    end
  end

  api :POST, '/staff', 'Creates a staff member'
  document_staff_params

  def create
    staff = Staff.create staff_params
    authorize staff
    respond_with staff
  end

  api :PUT, '/staff/:id', 'Updates a staff member with :id'
  param :id, :number, required: true
  document_staff_params
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def update
    staff.update_attributes staff_params
    respond_with staff
  end

  api :DELETE, '/staff/:id', 'Deletes staff member with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    staff.destroy
    respond_with staff
  end

  private

  def staff
    @staff ||= Staff.find(params.require(:id)).tap { |obj| authorize obj }
  end

  def staffs
    @staffs ||= begin
      authorize(Staff)
      if params[:query]
        apply_scopes(Staff.search(params[:query]))
      else
        query_with apply_scopes(Staff.all), :includes, :pagination
      end
    end
  end

  def staff_params
    params.permit(:first_name, :last_name, :email, :phone, :role, :password, :password_confirmation)
  end
end

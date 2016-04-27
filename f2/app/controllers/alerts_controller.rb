class AlertsController < ApplicationController
  after_action :verify_authorized
  after_action :post_hook

  before_action :pre_hook

  api :GET, '/alerts', 'Returns all alerts.'
  param :page, :number, required: false
  param :per_page, :number, required: false

  def index
    authorize Alert.new
    respond_with_params alerts
  end

  api :GET, '/alerts/:id', 'Shows alert with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    authorize alert
    respond_with_params alert
  end

  api :POST, '/alerts', 'Creates a new alert'
  # TODO: POLYMORPHIC ALERTS COULD HAVE MULTIPLE KINDS OF PARENT IDS, HOW TO PASS AND HANDLE THOSE IN URL PARAMS?
  param :status, String, required: false, desc: 'HTTP status code issued with this alert. <br>Valid Options: OK, WARNING, CRITICAL, UNKNOWN, PENDING'
  param :message, String, required: false, desc: 'The message content of the new alert.'
  param :category, String, required: false, desc: 'The category this alert is grouped under.'
  param :start_date, String, required: false, desc: 'Date this alert will begin appearing. Null indicates the alert will start appearing immediately.'
  param :end_date, String, required: false, desc: 'Date this alert should no longer be displayed after. Null indicates the alert does not expire.'
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    authorize Alert
    alert = Alert.create alert_params
    respond_with_params alert
  end

  api :PUT, '/alerts/:id', 'Updates alert with given :id'
  param :status, String, required: false, desc: 'HTTP status code issued with this alert. <br>Valid Options: OK, WARNING, CRITICAL, UNKNOWN, PENDING'
  param :message, String, required: false, desc: 'The message content to update alert with.'
  param :category, String, required: false, desc: 'The category this alert is grouped under.'
  param :start_date, String, required: false, desc: 'Date this alert will begin appearing. Null indicates the alert will start appearing immediately.'
  param :end_date, String, required: false, desc: 'Date this alert should no longer be displayed after. Null indicates the alert does not expire.'

  def update
    authorize alert
    alert.update alert_params
    respond_with_params alert
  end

  api :DELETE, '/alerts/:id', 'Deletes alert with :id'

  def destroy
    authorize alert
    alert.destroy
    respond_with alert
  end

  private

  def alert
    @_alert ||= Alert.find(params[:id])
  end

  def alerts
    query = policy_scope(Alert)
    query = apply_active_or_inactive(query)
    query = apply_not_status(query)
    query = apply_latest(query)
    query = apply_alertable_type(query)
    @_alerts = query_with query.where(nil), :includes, :pagination
  end

  def apply_alertable_type(query)
    if params[:alertable_type].present?
      query = query.alertable_type(params[:alertable_type])
    end
    query
  end

  def apply_latest(query)
    if params[:latest].present?
      query = params[:latest] == 'true' ? query.latest : query
    end
    query
  end

  def apply_active_or_inactive(query)
    if params[:active].present?
      query = params[:active] == 'true' ? query.active : query.inactive
    end
    if params[:inactive].present?
      query = params[:inactive] == 'true' ? query.inactive : query.active
    end
    query
  end

  def apply_not_status(query)
    if params[:not_status].present?
      (%w(ok warning critical pending unknown) & params[:not_status]).each do |status|
        query = query.not_status(status)
      end
    end
    query
  end

  def alert_params
    @_alert_params ||= params.permit(:id, :status, :message, :category, :start_date, :end_date, :alertable_type, :alertable_id)
  end
end

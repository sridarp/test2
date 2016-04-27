class ServiceOperationsController < ApplicationController
  def_param_group :service_operation_params do
    param :id, Integer, desc: 'ID of the service acted upon', allow_nil: false
    param :operation, String, desc: 'Name of the operation to execute on the service', allow_nil: false
  end

  api :PUT, '/services/:id/operations/:operation', 'Updates service :id with operation :operation'
  param_group :service_operation_params
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    authorize service, :operations?
    service.start_operation params[:operation]
    respond_with service
  end

  private

  def service
    @_service = Service.find params[:id]
  end
end

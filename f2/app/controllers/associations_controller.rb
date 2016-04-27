class AssociationsController < ApplicationController
  after_action :verify_authorized

  def_param_group :association do
    param :group_id, :number, required: true, desc: 'ID of group to change staff on'
    param :staff_id, :number, required: true, desc: 'ID of staff to change association of'
  end

  api :POST, '/groups/:group_id/staff/:staff_id', 'Add staff to a group'
  param_group :association
  def create
    authorize group
    group.staff << staff
    head :ok
  end

  api :DELETE, '/groups/:group_id/staff/:staff_id', 'Remove staff from a group'
  param_group :association
  def destroy
    authorize group
    group.staff.delete staff if group.staff.find staff.id
    head :ok
  end

  private

  def group
    @_group ||= Group.find params[:group_id]
  end

  def staff
    @_staff ||= Staff.find params[:staff_id]
  end
end

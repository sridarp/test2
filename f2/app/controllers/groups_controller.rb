class GroupsController < ApplicationController
  GROUP_INCLUDES = %w(memberships projects groups_staff staff).freeze

  api :GET, '/groups', 'Returns a collection of groups'
  param :includes, Array, in: GROUP_INCLUDES
  param :page, :number
  param :per_page, :number
  error code: 422, desc: ParameterValidation::Messages.missing

  def index
    authorize Group
    respond_with_params groups
  end

  api :GET, '/groups/:id', 'Shows group with :id'
  param :id, :number, required: true
  param :includes, Array, in: GROUP_INCLUDES
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def show
    authorize group
    respond_with_params group
  end

  api :POST, '/groups', 'Creates group'
  param :name, String, desc: 'Group Name', required: true
  param :description, String, desc: 'Group Description'
  param :staff_ids, Array
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    group = Group.create group_params
    if params[:staff_ids]
      group.groups_staff.create(params[:staff_ids].map { |id| { staff_id: id } })
    end
    authorize group
    respond_with_params group
  end

  api :PUT, '/groups/:id', 'Updates group with :id'
  param :id, :number, required: true
  param :name, String, desc: 'Group Name'
  param :description, String, desc: 'Group Description'
  param :staff_ids, Array
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    authorize group
    group.update! group_params
    update_group_staff
    respond_with_params group
  end

  api :DELETE, '/groups/:id', 'Deletes group with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize group
    group.destroy
    respond_with_params group
  end

  private

  def update_group_staff
    groups_staff = group.groups_staff
    staff_ids = params[:staff_ids]

    staff_ids.each do |id|
      unless groups_staff.detect { |gs| gs.staff_id == id }
        group.groups_staff.create staff_id: id
      end
    end

    groups_staff.each do |gs|
      unless staff_ids.detect { |id| gs.staff_id == id }
        GroupsStaff.destroy(gs.id)
      end
    end
  end

  def group_params
    params.permit :name, :description, :staff_ids
  end

  def groups
    @_groups ||= query_with Group.order('id').all, :includes, :pagination
  end

  def group
    @_group ||= Group.find params[:id]
  end
end

class MembershipsController < ApplicationController
  MEMBERSHIP_INCLUDES = %w(group project role).freeze

  after_action :verify_authorized

  api :GET, '/projects/:project_id/memberships', 'Get all memberships on a project'
  param :project_id, :number, 'ID of Project', required: true
  param :includes, Array, in: MEMBERSHIP_INCLUDES
  param :page, :number
  param :per_page, :number

  def index
    authorize Membership
    respond_with_params memberships
  end

  api :GET, '/memberships/:id', 'Get membership information'
  param :id, :number, 'ID of Membership', required: true
  param :includes, Array, in: MEMBERSHIP_INCLUDES
  param :page, :number
  param :per_page, :number

  def show
    authorize membership
    respond_with membership
  end

  api :POST, '/projects/:project_id/memberships', 'Add a group membership to a project'
  param :project_id, :number, 'ID of Project to add group membership to', required: true
  param :group_id, :number, 'ID of Group to associate with the project', required: true
  param :role_id, :number, 'ID of Role to associate with the group', required: true
  error code: 422, desc: ParameterValidation::Messages.missing
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def create
    membership = project.memberships.build membership_params
    authorize membership
    membership.save
    respond_with membership
  end

  api :PUT, '/memberships/:id', 'Update the group or role of a membership'
  param :id, :number, desc: 'The membership id'
  error code: 422, desc: ParameterValidation::Messages.missing
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def update
    authorize membership
    membership.update! role: Role.find(params[:role_id]), group: Group.find(params[:group_id])
    respond_with membership
  end

  api :DELETE, '/memberships/:id', 'Remove a membership from a project'
  param :id, :number, desc: 'The membership id'
  error code: 422, desc: ParameterValidation::Messages.missing
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize membership
    membership.destroy
    respond_with membership
  end

  private

  def membership_params
    params.permit(:group_id, :project_id, :role_id)
  end

  def project
    @project ||= Project.find params[:project_id]
  end

  def memberships
    @memberships ||= query_with Membership.where(project: project), :includes, :pagination
  end

  def membership
    @membership ||= Membership.find params[:id]
  end
end

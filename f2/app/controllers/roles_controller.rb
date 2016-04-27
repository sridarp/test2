class RolesController < ApplicationController
  def self.document_params(required: false)
    param :name, String, desc: 'Name of the role', required: required
    param :description, String, desc: 'Description of the role', required: required
    param :permissions, Hash, desc: %(Hash of permissions allowed, such as { projects: ["read", "write"] }. Valid keys: #{Role::PERMISSIONS}.), required: required do
      param :projects, Array, required: required, allow_nil: true
      param :approvals, Array, required: required, allow_nil: true
      param :memberships, Array, required: required, allow_nil: true
    end
  end

  api :GET, '/roles', 'Returns all roles'
  def index
    respond_with_params roles
  end

  api :GET, '/roles/:id', 'Returns roles with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    respond_with role
  end

  api :POST, '/roles', 'Create a role'
  document_params required: true

  def create
    role = Role.new role_params
    authorize role
    role.save
    respond_with role
  end

  api :PUT, '/roles/:id', 'Update a role'
  document_params

  def update
    respond_with_params role.update_attributes role_params
  end

  api :DELETE, '/roles/:id', 'Destroy a role'
  def destroy
    respond_with_params role.destroy
  end

  private

  def role_params
    params.permit(:name, :description, permissions: { projects: [], approvals: [], memberships: [] })
  end

  def role
    @role = Role.find(params.require(:id)).tap { |r| authorize(r) }
  end

  def roles
    authorize Role
    @roles = Role.all
  end
end

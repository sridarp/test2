class StaffPermissionsController < ApplicationController
  after_action :verify_authorized

  def show
    render json: permissions.all
  end

  private

  def project
    @_project ||= Project.find(params[:project_id]).tap { |pr| authorize pr }
  end

  def permissions
    @_permissions ||= Permissions.new(user: current_user, object: project)
  end
end

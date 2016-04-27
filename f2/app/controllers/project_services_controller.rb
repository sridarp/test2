class ProjectServicesController < ApplicationController
  after_action :verify_authorized

  api :GET, '/project/:project_id/services', 'Returns a collection of services related to a project'
  param :includes, Array, in: %w(project order product product_type)
  param :page, :number
  param :per_page, :number

  def index
    respond_with_params services, each_serializer: ServiceSerializer
  end

  private

  def project
    @_project ||= Project.find(params[:project_id]).tap { |p| authorize p }
  end

  def services
    @_services ||= query_with project.services, :includes, :pagination
  end
end

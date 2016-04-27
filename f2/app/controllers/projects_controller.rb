class ProjectsController < ApplicationController
  include Wisper::Publisher

  PROJECT_INCLUDES = %w(tags answers memberships groups staff alerts latest_alerts approvals approvers orders services).freeze
  PROJECT_METHODS = %w(problem_count state state_ok).freeze

  before_action :pre_hook
  after_action :verify_authorized
  after_action :post_hook

  has_scope :approved, type: :boolean
  has_scope :archived, type: :boolean

  def_param_group :project do
    param :name, String, action_aware: true
    param :budget, :decimal, precision: 12, scale: 2, action_aware: true
    param :description, String
    param :end_date, String, action_aware: true
    param :img, String
    param_group :answers, ApplicationController
  end

  api :GET, '/projects', 'Returns a collection of projects'
  param :includes, Array, in: PROJECT_INCLUDES
  param :methods, Array, in: PROJECT_METHODS
  param :page, :number
  param :per_page, :number

  def index
    authorize Project
    respond_with_params projects, index_respond_options
  end

  api :GET, '/projects/:id', 'Shows project with :id'
  param :id, :number, required: true
  param :includes, Array, in: PROJECT_INCLUDES
  param :methods, Array, in: PROJECT_METHODS
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    authorize project
    respond_with_params project
  end

  api :POST, '/projects', 'Creates projects'
  param_group :project
  param :start_date, String, required: true
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    authorize Project
    project = Project.create project_params
    publish(:project_create, project, current_user) if project.persisted?
    respond_with_params project
  end

  api :PUT, '/projects/:id', 'Updates project with :id'
  param :id, :number, required: true
  param_group :project
  param :includes, Array, in: PROJECT_INCLUDES
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    authorize project
    project.update project_params
    respond_with_params project
  end

  api :DELETE, '/projects/:id', 'Deletes project with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize project
    project.update archived: DateTime.now.utc
    respond_with project
  end

  private

  def index_respond_options
    { each_serializer: ProjectSerializer, except: [:start_date, :end_date, :created_at, :updated_at, :deleted_at] }
  end

  def project_params
    @_project_params ||= begin
      permitted = [
        :name, :description, :start_date, :end_date, :img, answers: [:id, :name, :value, :value_type]
      ]
      permitted.push(:budget, :monthly_budget) if current_user.admin? || params[:id].nil?
      params.permit(permitted).tap do |project|
        project[:answers_attributes] = project.delete(:answers) if project[:answers]
      end
    end
  end

  def projects
    @_projects ||= query_with apply_scopes(policy_scope(Project.all)), :includes, :pagination
  end

  def project
    @_project ||= Project.find(params[:id])
  end
end

class ProjectQuestionsController < ApplicationController
  after_action :verify_authorized

  def_param_group :project_question do
    param :question, String, desc: 'Question', action_aware: true
    param :field_type, String, desc: 'Field Type', in: ProjectQuestion.field_types.keys, action_aware: true
    param :help_text, String, desc: 'Help Text', allow_nil: true
    param :required, :bool, desc: 'Required?', action_aware: true
    param :options, Array, desc: 'Options', allow_nil: true
  end

  api :GET, '/project_questions', 'Returns a collection of project_questions'
  param :page, :number, required: false
  param :per_page, :number, required: false
  param :includes, Array, required: false, in: %w(project)

  def index
    respond_with_params project_questions
  end

  api :GET, '/project_questions/:id', 'Shows project_question with :id'
  param :id, :number, required: true
  param :includes, Array, required: false, in: %w(project)
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    respond_with_params project_question
  end

  api :POST, '/project_questions', 'Creates project_question'
  param_group :project_question
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    authorize ProjectQuestion
    respond_with ProjectQuestion.create project_question_params
  end

  api :PUT, '/project_questions/:id', 'Updates project_question with :id'
  param_group :project_question
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    respond_with project_question.update_attributes project_question_params
  end

  api :DELETE, '/project_questions/:id', 'Deletes project_question with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    project_question.delete
    respond_with project_question
  end

  api :PUT, '/project_questions/:id/reposition', 'Repositions the project question'
  param :id, :number, required: true
  param :position, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def reposition
    project_question.insert_at project_question_params[:position]
    respond_with project_question
  end

  private

  def project_question_params
    params.permit(:uuid, :question, :field_type, :help_text, :required, :options)
  end

  def project_question
    @project_question ||= ProjectQuestion.find(params.require(:id)).tap { |q| authorize q }
  end

  def project_questions
    @project_questions ||= begin
      authorize ProjectQuestion
      query_with ProjectQuestion.ordered, :includes, :pagination
    end
  end
end

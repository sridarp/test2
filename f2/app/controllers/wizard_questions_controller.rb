class WizardQuestionsController < ApplicationController
  api :GET, '/wizard_questions', 'List all wizard questions with answers'
  param :includes, Array, in: ['wizard_answers']
  param :page, :number
  param :per_page, :number

  def index
    respond_with_params wizard_questions
  end

  api :GET, '/wizard_questions/first', 'Return first question'
  param :includes, Array, in: ['wizard_answers']
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def first
    respond_with_params WizardQuestion.first
  end

  api :GET, '/wizard_questions/:id', 'Shows question with :id'
  param :id, :number, required: true
  param :includes, Array, in: ['wizard_answers']
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    respond_with_params wizard_question
  end

  api :POST, '/wizard_questions', 'Create a wizard question'
  param :text, String, desc: 'Question text', required: true
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    wizard_question = WizardQuestion.create(wizard_question_params)

    respond_with_params wizard_question
  end

  api :PUT, '/wizard_questions/:id', 'Update a wizard question'
  param :text, String, desc: 'Question text', required: true
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    wizard_question = WizardQuestion.find(params[:id])

    wizard_question.update(wizard_question_params)

    respond_with_params wizard_question
  end

  api :DELETE, '/wizard_questions/:id', 'Delete a wizard question'

  def destroy
    wizard_question = WizardQuestion.find(params[:id])

    wizard_question.destroy

    head :ok
  end

  private

  def wizard_question_params
    if params[:wizard_answers]
      params[:wizard_answers_attributes] = params.delete(:wizard_answers)
    end

    params.permit(:id, :text, wizard_answers_attributes: [:id, :_destroy, :text, tags_to_add: [], tags_to_remove: []])
  end

  def wizard_questions
    @_questions ||= query_with WizardQuestion.order(:id), :includes, :pagination
  end

  def wizard_question
    @_question ||= (query_with WizardQuestion.where(id: params.require(:id)), :includes).first || raise(ActiveRecord::RecordNotFound)
  end
end

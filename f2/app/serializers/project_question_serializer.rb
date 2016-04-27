# == Schema Information
#
# Table name: project_questions
#
#  id         :integer          not null, primary key
#  question   :string(255)
#  help_text  :string(255)
#  required   :boolean
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#  position   :integer
#  options    :jsonb
#  field_type :integer          default(0)
#  uuid       :string
#
# Indexes
#
#  index_project_questions_on_deleted_at  (deleted_at)
#

class ProjectQuestionSerializer < ApplicationSerializer
  attributes :id, :uuid, :question, :help_text, :required
  attributes :created_at, :updated_at, :deleted_at, :position, :options, :field_type

  private

  def options
    object.options
  end
end

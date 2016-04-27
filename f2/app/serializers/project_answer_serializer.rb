# == Schema Information
#
# Table name: project_answers
#
#  id                  :integer          not null, primary key
#  project_id          :integer
#  project_question_id :integer
#  answer              :text
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_project_answers_on_project_id           (project_id)
#  index_project_answers_on_project_question_id  (project_question_id)
#

class ProjectAnswerSerializer < ApplicationSerializer
  attributes :id, :project_id, :answer, :created_at, :updated_at

  has_one :project_question
end

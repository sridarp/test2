# == Schema Information
#
# Table name: wizard_questions
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WizardQuestionSerializer < ApplicationSerializer
  attributes :id, :text

  has_many :wizard_answers
end

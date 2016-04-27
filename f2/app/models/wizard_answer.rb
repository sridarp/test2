# == Schema Information
#
# Table name: wizard_answers
#
#  id                 :integer          not null, primary key
#  wizard_question_id :integer
#  text               :string
#  tags_to_add        :string           default([]), is an Array
#  tags_to_remove     :string           default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_wizard_answers_on_wizard_question_id  (wizard_question_id)
#

class WizardAnswer < ActiveRecord::Base
  belongs_to :wizard_question
end

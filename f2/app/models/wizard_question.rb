# == Schema Information
#
# Table name: wizard_questions
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WizardQuestion < ActiveRecord::Base
  has_many :wizard_answers

  accepts_nested_attributes_for :wizard_answers, reject_if: :all_blank, allow_destroy: true

  def next_question_id
    self.class.find_by('id > ?', id).try(:id)
  end
end

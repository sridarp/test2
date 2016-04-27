# == Schema Information
#
# Table name: wizard_questions
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe WizardQuestion, type: :model do
  it { expect(subject).to have_many(:wizard_answers) }
end

describe 'WizardQuestion#next_question' do
  it 'returns to next question' do
    answer = create(:wizard_answer)
    first_question = create(:wizard_question, wizard_answers: [answer])
    next_question = create(:wizard_question, wizard_answers: [answer])

    expect(first_question.next_question_id).to eq next_question.id
  end
end

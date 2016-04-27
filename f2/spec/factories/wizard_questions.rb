# == Schema Information
#
# Table name: wizard_questions
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :wizard_question do
    text 'What programming language will be used?'

    trait :with_answers do
      after(:build) do |question, _|
        question.wizard_answers = build_pair(:wizard_answer)
      end
    end
  end
end

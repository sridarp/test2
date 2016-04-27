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

FactoryGirl.define do
  factory :project_question do
    question 'Question?'
    field_type :multiple
    help_text 'helping'

    options %w(One Two Three)

    required true
    position 0

    trait :optional do
      required false
    end

    trait :required_text do
      field_type :text
      position 1
      options %w()
    end
  end
end

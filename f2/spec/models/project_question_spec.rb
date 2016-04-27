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

describe ProjectQuestion do
  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:field_type) }

  context 'options' do
    let(:options) { %w(test1 test2) }

    it 'can store unstructured options' do
      create :project_question, options: options
      project_question = ProjectQuestion.first

      expect(project_question.options[0]).to eq(options[0]['test1'])
      expect(project_question.options[1]).to eq(options[1]['test2'])
    end
  end
end

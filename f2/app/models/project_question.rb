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

class ProjectQuestion < ActiveRecord::Base
  acts_as_paranoid
  acts_as_list top_of_list: 0

  scope :ordered, -> { order('position') }

  has_many :project_answers, dependent: :destroy

  store_accessor :options

  enum field_type: { yes_no: 0, multiple: 1, text: 2, date: 3, checkbox: 4 }

  validates :question, presence: true
  validates :field_type, presence: true

  before_create :ensure_uuid

  private

  def ensure_uuid
    self[:uuid] = SecureRandom.uuid if self[:uuid].nil?
  end
end

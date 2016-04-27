# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  staff_id   :integer
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_api_tokens_on_staff_id  (staff_id)
#

class ApiToken < ActiveRecord::Base
  belongs_to :staff
  before_create :generate_token

  def generate_token
    self.token = SecureRandom.hex 16
  end
end

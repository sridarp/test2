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

FactoryGirl.define do
  factory :api_token do
    staff
  end
end

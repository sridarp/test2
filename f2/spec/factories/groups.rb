# == Schema Information
#
# Table name: groups
#
#  id          :integer          not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string
#  description :text
#  staff_count :integer          default(0)
#

FactoryGirl.define do
  factory :group do
    name 'Group name'
    description 'Description of group'
  end
end

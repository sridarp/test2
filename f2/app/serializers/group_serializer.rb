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

class GroupSerializer < ApplicationSerializer
  attributes :id, :name, :description, :staff_count, :staff_ids

  has_many :staff
  has_many :memberships
  has_many :groups_staffs
end

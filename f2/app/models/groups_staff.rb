# == Schema Information
#
# Table name: groups_staff
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  group_id   :integer
#  staff_id   :integer
#
# Indexes
#
#  index_groups_staff_on_group_id  (group_id)
#  index_groups_staff_on_staff_id  (staff_id)
#

class GroupsStaff < ActiveRecord::Base
  self.table_name = 'groups_staff'
  belongs_to :staff
  belongs_to :group, counter_cache: :staff_count
end

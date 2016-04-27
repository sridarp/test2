# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  group_id   :integer
#  project_id :integer
#  role_id    :integer
#
# Indexes
#
#  index_memberships_on_group_id    (group_id)
#  index_memberships_on_project_id  (project_id)
#

FactoryGirl.define do
  factory(:membership) do
    group
    project
    role
  end
end

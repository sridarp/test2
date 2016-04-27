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

class MembershipSerializer < ApplicationSerializer
  attributes :id, :group_id, :project_id, :role_id, :created_at, :updated_at

  has_one :group
  has_one :project
  has_one :role
end

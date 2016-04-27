# == Schema Information
#
# Table name: approvals
#
#  id         :integer          not null, primary key
#  staff_id   :integer
#  project_id :integer
#  approved   :boolean
#  created_at :datetime
#  updated_at :datetime
#  reason     :text
#
# Indexes
#
#  index_approvals_on_project_id  (project_id)
#  index_approvals_on_staff_id    (staff_id)
#

class ApprovalSerializer < ApplicationSerializer
  attributes :id, :staff_id, :approved, :created_at, :updated_at, :reason
end

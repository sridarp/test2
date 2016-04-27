# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  img            :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  status         :integer          default(0)
#  archived       :datetime
#  spent          :decimal(12, 2)   default(0.0)
#  budget         :decimal(12, 2)   default(0.0)
#  start_date     :datetime
#  end_date       :datetime
#  health         :integer
#  monthly_spend  :decimal(12, 2)   default(0.0)
#  monthly_budget :decimal(12, 2)   default(0.0)
#
# Indexes
#
#  index_projects_on_archived    (archived)
#  index_projects_on_deleted_at  (deleted_at)
#

class ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :description, :img, :archived, :status, :health
  attributes :spent, :budget, :monthly_budget, :monthly_spend, :start_date, :end_date
  attributes :created_at, :updated_at, :deleted_at

  # Relationships
  has_many :answers
  has_many :memberships
  has_many :groups
  has_many :staff
  has_many :alerts
  has_many :latest_alerts
  has_many :approvals
  has_many :approvers, serializer: StaffSerializer
  has_many :services
  has_many :orders

  def health
    object.pending? ? nil : object.health
  end
end

# == Schema Information
#
# Table name: project_details
#
#  id                         :integer          not null, primary key
#  requestor_name             :string
#  requestor_date             :date
#  team_name                  :string
#  charge_number              :integer
#  nte_budget                 :float
#  project_owner              :string
#  sr_associate               :string
#  principal                  :string
#  estimated_termination_date :date
#  data_type                  :string
#  others                     :string
#  project_id                 :integer
#
# Indexes
#
#  index_project_details_on_project_id  (project_id)
#

class ProjectDetailSerializer < ApplicationSerializer
  attributes :id, :requestor_name, :requestor_date, :team_name, :charge_number, :nte_budget
  attributes :project_owner, :sr_associate, :principle, :estimated_termination_date, :data_type, :others
end

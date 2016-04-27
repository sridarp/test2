# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  permissions :jsonb
#

FactoryGirl.define do
  factory :role do
    name 'Administrator'
    description 'Administration things'
    permissions(
      'projects' => %w(read write),
      'approvals' => %w(read write),
      'memberships' => %w(read write)
    )
  end
end

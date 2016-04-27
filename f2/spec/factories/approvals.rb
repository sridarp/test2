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

FactoryGirl.define do
  factory :approval do
    staff_id 1
    project_id 1
    approved true

    trait :unapproved do
      approved false
      reason 'Unapproved'
    end
  end
end

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

FactoryGirl.define do
  factory :project do
    sequence :name do |n|
      "Project Name #{n}"
    end
    sequence :description do |n|
      "Project description #{n}"
    end
    budget 100.0
    spent 0.0
    monthly_spend 0
    start_date((Time.zone.now + 1.week).to_date)
    end_date((Time.zone.now + 2.weeks).to_date)
    img '/images/no_image.png'
    status :undecided
    health :pending

    trait :approved do
      status :approved
      health :ok
      approval :approved
    end

    trait :rejected do
      status :rejected
      approval :rejected
    end
  end
end

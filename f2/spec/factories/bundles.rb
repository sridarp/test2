# == Schema Information
#
# Table name: bundles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  img         :string
#  active_at   :datetime
#  deleted_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :bundle do
    sequence :name do |n|
      "Bundle Name #{n}"
    end
    sequence :description do |n|
      "Bundle description #{n}"
    end
    img 'bundle.png'
    active true

    after :build do |bundle|
      bundle.products ||= build_pair(:product)
    end
  end
end

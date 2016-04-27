# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  img         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#
# Indexes
#
#  index_organizations_on_deleted_at  (deleted_at)
#

FactoryGirl.define do
  factory :organization do
    name 'test'
    img 'test.png'
    description 'test desc'
    created_at '2014-11-17T20:00:57.711Z'
    updated_at '2014-11-17T20:00:57.711Z'
  end
end

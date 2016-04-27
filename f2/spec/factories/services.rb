# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string           not null
#  uuid       :string           not null
#  name       :string           not null
#  health     :integer          default(0), not null
#  status     :integer
#  status_msg :string
#
# Indexes
#
#  index_services_on_type  (type)
#  index_services_on_uuid  (uuid)
#

FactoryGirl.define do
  factory :service do
    type 'Service'

    sequence :name do |n|
      "Service #{n}"
    end

    product
    uuid SecureRandom.uuid
    health :ok
    status :pending
  end
end

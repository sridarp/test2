# == Schema Information
#
# Table name: service_outputs
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :integer          not null
#  name       :string           not null
#  value      :text
#  value_type :integer
#
# Indexes
#
#  index_service_outputs_on_service_id  (service_id)
#

class ServiceOutput < ActiveRecord::Base
  include ValueTypes

  belongs_to :service

  validates :name, presence: true

  before_save :convert_value
end

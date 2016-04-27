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

class ServiceSerializer < ApplicationSerializer
  attributes :id, :type, :name, :uuid, :status, :health, :status_msg, :created_at, :updated_at

  # Relationships
  has_one :order, serializer: OrderSerializer
  has_one :project, serializer: ProjectSerializer
  has_one :product, serializer: ProductSerializer
  has_one :product_type, serializer: ProductTypeSerializer
  has_one :provider, serializer: ProviderSerializer

  has_many :logs, serializer: LogSerializer
  has_many :service_outputs
end

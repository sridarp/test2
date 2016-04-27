# == Schema Information
#
# Table name: product_types
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  type          :string           not null
#  name          :string           not null
#  uuid          :string           not null
#  active        :boolean          default(TRUE), not null
#  provider_type :string           not null
#
# Indexes
#
#  index_product_types_on_provider_type  (provider_type)
#  index_product_types_on_type           (type)
#  index_product_types_on_uuid           (uuid)
#

class ProductTypeSerializer < ApplicationSerializer
  attributes :id, :type, :name, :provider, :description, :tags, :product_questions, :active

  def provider
    object.provider_type.split('::').last
  end
end

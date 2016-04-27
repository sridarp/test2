# == Schema Information
#
# Table name: product_instances
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type                :string           not null
#  project_id          :integer          not null
#  product_id          :integer          not null
#  status              :integer
#  status_msg          :string
#  properties          :json
#  reported_properties :json
#  fulfilled_at        :datetime
#
# Indexes
#
#  index_product_instances_on_product_id  (product_id)
#  index_product_instances_on_project_id  (project_id)
#

class ProductInstance < ActiveRecord::Base
  belongs_to :product
  belongs_to :project
end

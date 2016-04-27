# == Schema Information
#
# Table name: bundled_products
#
#  id         :integer          not null, primary key
#  bundle_id  :integer
#  product_id :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_bundled_products_on_bundle_id   (bundle_id)
#  index_bundled_products_on_product_id  (product_id)
#

class BundledProduct < ActiveRecord::Base
  belongs_to :bundle
  belongs_to :product
end

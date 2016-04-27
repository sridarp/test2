# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  description     :text
#  active          :boolean          default(TRUE)
#  img             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  deleted_at      :datetime
#  setup_price     :decimal(10, 4)   default(0.0)
#  hourly_price    :decimal(10, 4)   default(0.0)
#  monthly_price   :decimal(10, 4)   default(0.0)
#  cached_tag_list :string
#  provider_id     :integer
#  product_type_id :integer
#  type            :string           default("Product"), not null
#
# Indexes
#
#  index_products_on_deleted_at       (deleted_at)
#  index_products_on_product_type_id  (product_type_id)
#  index_products_on_provider_id      (provider_id)
#

FactoryGirl.define do
  factory :product do
    active true
    img 'product.png'

    sequence :name do |n|
      "Product Name #{n}"
    end

    sequence :description do |n|
      "Product description #{n}"
    end

    product_type
  end
end

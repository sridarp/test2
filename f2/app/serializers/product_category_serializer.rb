# == Schema Information
#
# Table name: product_categories
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :string
#  img             :string
#  cached_tag_list :string
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class ProductCategorySerializer < ApplicationSerializer
  attributes :id, :name, :description, :img, :created_at, :updated_at, :deleted_at
  attribute :tag_list, key: :tags
end

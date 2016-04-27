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

class ProductCategory < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable
end

# == Schema Information
#
# Table name: bundles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  img         :string
#  active_at   :datetime
#  deleted_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Bundle < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable

  has_many :bundled_products
  has_many :products, through: :bundled_products

  time_for_a_boolean :active
end

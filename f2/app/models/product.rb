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

class Product < ActiveRecord::Base
  include Answers

  acts_as_paranoid
  acts_as_taggable

  belongs_to :provider
  belongs_to :product_type
  has_many :services

  accepts_nested_attributes_for :answers

  after_initialize :init

  scope :active, -> { where(active: true) }

  # TODO: Move contents of ProductType.order_questions here after removal of deprecated method
  delegate :order_questions, to: :product_type

  # TODO: Move contents of ProductType.service_class here after removal of deprecated method
  delegate :service_class, to: :product_type

  def self.policy_class
    ProductPolicy
  end

  def monthly_cost
    monthly_price + (hourly_price * 750)
  end

  private

  def init
    self.setup_price ||= 0.0
    self.hourly_price ||= 0.0
    self.monthly_price ||= 0.0
  end
end

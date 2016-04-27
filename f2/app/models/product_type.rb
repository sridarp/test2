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

class ProductType < ActiveRecord::Base
  has_many :products

  validates :name, presence: true, allow_nil: false, allow_blank: false
  validates :uuid, presence: true, allow_nil: false, allow_blank: false
  validates :provider_type, presence: true, allow_nil: false, allow_blank: false

  def self.create(opts)
    ProductType.inheritance_column = :_type_disabled
    product_type = ProductType.find_by uuid: opts[:uuid]
    product_type.nil? ? super(opts) : create_existing(product_type, opts)
    ProductType.inheritance_column = :type
  end

  def self.create!(opts)
    ProductType.inheritance_column = :_type_disabled
    product_type = ProductType.find_by uuid: opts[:uuid]
    product_type.nil? ? super(opts) : create_existing(product_type, opts)
    ProductType.inheritance_column = :type
  end

  def self.policy_class
    ProductTypePolicy
  end

  def description
    ''
  end

  def tags
    []
  end

  def product_questions
    []
  end

  def order_questions
    ActiveSupport::Deprecation.warn 'ProductType.order_questions will be removed in a future update, use Product.order_questions instead', caller
    []
  end

  def product_class
    'Product'.constantize
  end

  def service_class
    ActiveSupport::Deprecation.warn 'ProductType.service_class will be removed in a future update, use Product.service_class instead', caller
    'Service'.constantize
  end

  def self.create_existing(product_type, opts)
    columns = [:name, :provider_type]
    to_update = Hash[opts.select { |k, _| columns.include? k }]
    product_type.update_attributes to_update
    product_type.update_column :type, opts[:type] if product_type.type != opts[:type]
    product_type
  end

  def self.load_product_types
    ProductType.table_exists?
  rescue
    false
  end

  def self.set(name, uuid, options)
    keys = %i(provider_type)
    {
      name: name,
      uuid: uuid,
      provider_type: 'Provider'
    }.merge options.keep_if { |key| keys.include? key }
  end
end

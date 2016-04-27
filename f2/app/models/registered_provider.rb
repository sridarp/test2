# == Schema Information
#
# Table name: registered_providers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#  type       :string           not null
#  name       :string           not null
#  uuid       :string           not null
#
# Indexes
#
#  index_registered_providers_on_type  (type)
#  index_registered_providers_on_uuid  (uuid)
#

class RegisteredProvider < ActiveRecord::Base
  acts_as_paranoid

  has_many :providers

  def self.create(opts)
    RegisteredProvider.inheritance_column = :_type_disabled
    registered_provider = RegisteredProvider.find_by uuid: opts[:uuid]
    registered_provider.nil? ? super(opts) : create_existing(registered_provider, opts)
    RegisteredProvider.inheritance_column = :type
  end

  def self.create!(opts)
    RegisteredProvider.inheritance_column = :_type_disabled
    registered_provider = RegisteredProvider.find_by uuid: opts[:uuid]
    registered_provider.nil? ? super(opts) : create_existing(registered_provider, opts)
    RegisteredProvider.inheritance_column = :type
  end

  def self.policy_class
    RegisteredProviderPolicy
  end

  def provider_class
    'Provider'.constantize
  end

  def description
    ''
  end

  def tags
    []
  end

  def questions
    []
  end

  def self.create_existing(registered_provider, opts)
    columns = %i(name)
    to_update = Hash[opts.select { |k, _| columns.include? k }]
    registered_provider.update_attributes to_update
    registered_provider.update_column :type, opts[:type] if registered_provider.type != opts[:type]
    registered_provider
  end

  def self.load_registered_providers
    RegisteredProvider.table_exists?
  rescue
    false
  end

  def self.set(name, uuid)
    {
      name: name,
      uuid: uuid
    }
  end
end

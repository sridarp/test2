# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string           not null
#  uuid       :string           not null
#  name       :string           not null
#  health     :integer          default(0), not null
#  status     :integer
#  status_msg :string
#
# Indexes
#
#  index_services_on_type  (type)
#  index_services_on_uuid  (uuid)
#

class Service < ActiveRecord::Base
  include Answers

  has_many :alerts, as: :alertable
  has_many :latest_alerts, -> { latest }, class_name: 'Alert', as: :alertable
  has_many :service_outputs
  has_many :logs, as: :loggable, dependent: :destroy

  belongs_to :order
  has_one :project, through: :order
  belongs_to :product
  has_one :product_type, through: :product
  has_one :provider, through: :product

  enum health: { ok: 0, warning: 1, critical: 2 }
  enum status: {
    unknown: 0,
    pending: 1,
    provisioning: 2,
    starting: 3,
    running: 4,
    available: 5,
    stopping: 6,
    stopped: 7,
    unavailable: 8,
    retired: 9,
    terminated: 10
  }

  accepts_nested_attributes_for :answers

  before_create :ensure_uuid

  def self.policy_class
    ServicePolicy
  end

  def operations
    []
  end

  def start_operation(operation)
    message = operation.to_sym
    send(message) if respond_to? message
  end

  def actions
    ActiveSupport::Deprecation.warn 'Service.actions will be removed in a future update, use Service.operations instead', caller
    operations
  end

  def provision
  end

  private

  def ensure_uuid
    self[:uuid] = SecureRandom.uuid if self[:uuid].nil?
  end
end

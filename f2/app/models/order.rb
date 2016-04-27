# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  staff_id      :integer          not null
#  project_id    :integer          not null
#  setup_price   :decimal(10, 4)
#  hourly_price  :decimal(10, 4)
#  monthly_price :decimal(10, 4)
#  status        :integer          default(0)
#  status_msg    :string
#
# Indexes
#
#  index_orders_on_project_id  (project_id)
#  index_orders_on_staff_id    (staff_id)
#

class Order < ActiveRecord::Base
  belongs_to :staff
  belongs_to :project
  has_many :services
  has_many :products, through: :services

  # Columns
  enum status: { pending: 0, working: 1, completed: 2, failed: 3 }

  after_initialize :init
  after_commit :update_project_monthly_spend, on: :create

  def monthly_cost
    monthly_price + (hourly_price * 750)
  end

  private

  def init
    self.setup_price ||= 0.0
    self.hourly_price ||= 0.0
    self.monthly_price ||= 0.0
  end

  def update_project_monthly_spend
    project.increment :monthly_spend, monthly_cost
    project.save
  end
end

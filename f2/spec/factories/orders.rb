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

FactoryGirl.define do
  factory :order do
    setup_price 0.0
    monthly_price 0.0
    hourly_price 0.0

    staff
  end
end

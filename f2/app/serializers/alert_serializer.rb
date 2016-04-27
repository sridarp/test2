# == Schema Information
#
# Table name: alerts
#
#  id             :integer          not null, primary key
#  status         :string(20)
#  message        :text
#  start_date     :datetime
#  end_date       :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  alertable_id   :integer
#  alertable_type :string
#  category       :string
#
# Indexes
#
#  index_alerts_on_alertable_id  (alertable_id)
#  index_alerts_on_end_date      (end_date)
#  index_alerts_on_start_date    (start_date)
#

class AlertSerializer < ApplicationSerializer
  attributes :id, :status, :message, :alertable_type, :alertable_id
  attributes :start_date, :end_date, :created_at, :updated_at, :category
end

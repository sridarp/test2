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

class Alert < ActiveRecord::Base
  acts_as_taggable

  belongs_to :alertable, polymorphic: true

  scope :active, -> { where('(alerts.start_date <= NOW() OR alerts.start_date IS NULL) AND (alerts.end_date >= NOW() OR alerts.end_date IS NULL)') }
  scope :inactive, -> { where('end_date < NOW() OR start_date > NOW()') }
  scope :latest, -> { where(id: group('alertable_type, alertable_id, category').select('max(id) as latest_alert_id')) }
  scope :not_status, ->(status) { where('alerts.status != ?', status) }
  scope :alertable_type, ->(alertable_type) { where('alertable_type = ?', alertable_type) }
  scope :newest_first, -> { order('updated_at DESC') }
  scope :oldest_first, -> { order(:updated_at) }
  scope :max_by_status, -> { order((%w(unknown ok pending warning critical).map { |s| "alerts.status = '#{s}'" }.join ', ')).limit 1 }

  after_commit :cache_alert_data, on: [:create, :update]

  def cache_alert_data
    project.compute_current_status! if alertable == Project
  end
end

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

FactoryGirl.define do
  factory :alert do
    status 'ok'
    message 'This is a test alert'
    category 'foobar'
    start_date 'NULL'
    end_date 'NULL'

    trait :warning do
      status 'warning'
      message 'This is a WARNING alert.'
      category 'foobar'
    end

    trait :critical do
      status 'critical'
      message 'This is a CRITICAL alert.'
      category 'foobar'
    end

    trait :unknown do
      status 'unknown'
      message 'This is an UNKNOWN alert.'
      category 'foobar'
    end

    trait :active do
      status 'warning'
      message 'This alert is within its start and end dates.'
      category 'foobar'
      start_date Time.zone.now.to_s # START DATE NOW
      end_date((Time.zone.now + 1.day).to_s) # END DATE NOT SET
    end

    trait :inactive do
      status 'warning'
      message 'This alert is not within its start and end dates.'
      category 'foobar'
      start_date((Time.zone.now - 2.days).to_s) # YESTERDAY - 1
      end_date((Time.zone.now - 1.day).to_s) # YESTERDAY
    end
  end
end

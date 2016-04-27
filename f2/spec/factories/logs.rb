# == Schema Information
#
# Table name: logs
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  log_level     :integer
#  message       :text
#  loggable_type :string
#  loggable_id   :integer
#

FactoryGirl.define do
  factory :log do
    log_level 1
    message 'Test message'

    loggable
  end

  factory :service_log, class: 'Log' do
    association :loggable, factory: :log
  end
end

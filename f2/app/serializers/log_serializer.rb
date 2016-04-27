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

class LogSerializer < ApplicationSerializer
  attributes :id, :log_level, :message, :loggable_type, :loggable_id, :created_at, :updated_at
end

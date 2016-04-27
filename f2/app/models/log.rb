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

class Log < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true

  enum log_level: {
    debug: 0,
    info: 1,
    warning: 2,
    error: 3,
    fatal: 4
  }
end

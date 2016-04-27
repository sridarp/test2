# == Schema Information
#
# Table name: motds
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#  staff_id   :integer
#  message    :text
#
# Indexes
#
#  index_motds_on_staff_id  (staff_id)
#

class Motd < ActiveRecord::Base
  validates :message, presence: true
  validates :staff_id, presence: true
end

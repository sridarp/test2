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

FactoryGirl.define do
  factory :motd do
    message '"Message of the Day" or "Motto of the Day" (MOTD): A regularly updated message used to send a common message to all users, in a more efficient manner than sending them all an e-mail message.'
    staff_id 1
  end
end

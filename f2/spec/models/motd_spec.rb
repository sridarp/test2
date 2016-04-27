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

describe Motd do
  it 'has a valid factory' do
    expect(build(:motd)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of :message }
    it { is_expected.to validate_presence_of :staff_id }
  end
end

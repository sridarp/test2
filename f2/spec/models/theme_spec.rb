# == Schema Information
#
# Table name: themes
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  description :text
#  config      :json
#

require 'rails_helper'

describe Theme do
  it 'has a valid factory' do
    expect(build(:theme)).to be_valid
  end
end

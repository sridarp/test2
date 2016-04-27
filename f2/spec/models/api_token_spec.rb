# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  staff_id   :integer
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_api_tokens_on_staff_id  (staff_id)
#

require 'rails_helper'

describe 'ApiToken#create' do
  it 'sets the token to a randomly generated string' do
    api_token = create(:api_token)

    expect(api_token.token.length).to eq(32)
  end
end

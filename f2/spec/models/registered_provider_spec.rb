# == Schema Information
#
# Table name: registered_providers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#  type       :string           not null
#  name       :string           not null
#  uuid       :string           not null
#
# Indexes
#
#  index_registered_providers_on_type  (type)
#  index_registered_providers_on_uuid  (uuid)
#

require 'rails_helper'

RSpec.describe RegisteredProvider, type: :model do
  let(:registered_provider) { create :registered_provider }

  it 'has a valid factory' do
    expect(registered_provider).to be_valid
  end

  it 'sets the type' do
    expect(registered_provider).to have_attributes(type: a_string_starting_with('RegisteredProvider::Type'))
  end
end

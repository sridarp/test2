# == Schema Information
#
# Table name: providers
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted_at             :datetime
#  type                   :string           not null
#  registered_provider_id :integer          not null
#  name                   :string           not null
#  description            :text
#  active                 :boolean
#  cached_tag_list        :string
#
# Indexes
#
#  index_providers_on_registered_provider_id  (registered_provider_id)
#  index_providers_on_type                    (type)
#

require 'rails_helper'

RSpec.describe Provider, type: :model do
  let(:registered_provider) { create :registered_provider }
  let(:provider) { create :provider, registered_provider: registered_provider }

  it 'has a valid factory' do
    expect(provider).to be_valid
  end

  it 'sets the type' do
    expect(provider).to have_attributes(type: a_string_starting_with('Provider::Type'))
  end

  it 'sets the registered_provider_id field' do
    expect(provider.registered_provider_id).to eq(registered_provider.id)
  end

  it 'has a relationship with a registered provider' do
    expect(provider.registered_provider).to be(registered_provider)
  end
end

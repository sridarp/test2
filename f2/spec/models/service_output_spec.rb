# == Schema Information
#
# Table name: service_outputs
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :integer          not null
#  name       :string           not null
#  value      :text
#  value_type :integer
#
# Indexes
#
#  index_service_outputs_on_service_id  (service_id)
#

require 'rails_helper'

describe ServiceOutput do
  it 'has a valid factory' do
    expect(build(:service_output)).to be_valid
  end

  it 'inherits from ValueTypes' do
    expect(ServiceOutput.ancestors.include?(ValueTypes)).to be true
  end

  it 'can be added to services' do
    service = create :service

    service.service_outputs << build(:service_output)
    service.service_outputs << build(:service_output, :integer)
    service.service_outputs << build(:service_output, :email)

    service.save
    service.reload

    expect(service.service_outputs.length).to eq(3)
  end
end

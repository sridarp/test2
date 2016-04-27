require 'rails_helper'

RSpec.describe 'Bundles', :show_in_doc do
  describe 'create' do
    it 'adds related staff' do
      sign_in_as create(:staff, :admin)
      bundle_attributes = attributes_for(:bundle).stringify_keys!

      post('/api/v1/bundles.json', bundle_attributes)

      expect(response).to be_success
      expect(json.slice('name', 'description', 'slug'))
        .to match(bundle_attributes.slice('name', 'description', 'slug'))
    end
  end

  describe 'update' do
    it 'removes related staff' do
      sign_in_as create(:staff, :admin)
      bundle = create(:bundle)

      put("/api/v1/bundles/#{bundle.id}.json", name: 'new name')

      expect(response).to be_success
      expect(bundle.reload.name).to eq 'new name'
    end
  end
end

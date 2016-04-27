require 'rails_helper'

RSpec.describe 'Product Types API' do
  describe 'GET index' do
    it 'returns a collection of all product types' do
      sign_in_as create(:staff, :admin)

      create :product_type
      create :product_type

      get '/api/v1/product_types'

      expect(json.length).to eq 2
    end
  end
end

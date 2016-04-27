require 'rails_helper'

RSpec.describe 'Chargebacks API' do
  let(:default_params) { { format: :json } }

  describe 'GET index' do
    before(:each) do
      @chargeback1 = create :chargeback
      @chargeback2 = create :chargeback
      sign_in_as create :staff, :admin
      @chargebacks = Chargeback.all
    end

    it 'returns a collection of all of the chargebacks', :show_in_doc do
      get '/api/v1/chargebacks'
      expect(response.body).to eq(@chargebacks.to_json)
    end

    it 'returns a collection of all of the chargebacks w/ products', :show_in_doc do
      product = create :product
      @chargeback1.update_attributes(product_id: product.id)
      @chargeback2.update_attributes(product_id: product.id)

      get '/api/v1/chargebacks', includes: ['product']
      expect(json[0]['product']).to_not eq(nil)
    end

    it 'paginates the chargebacks' do
      get '/api/v1/chargebacks', page: 1, per_page: 1
      expect(json.length).to eq(1)
    end
  end

  describe 'GET show' do
    before(:each) do
      create :chargeback
      sign_in_as create :staff, :admin
      @chargeback = Chargeback.first
    end

    it 'returns an chargeback', :show_in_doc do
      get "/api/v1/chargebacks/#{@chargeback.id}"
      expect(response.body).to eq(@chargeback.to_json)
    end

    it 'returns an chargeback w/ a product', :show_in_doc do
      product = create :product
      @chargeback.update_attributes(product_id: product.id)

      get "/api/v1/chargebacks/#{@chargeback.id}", includes: ['product']
      expect(json['product']).to_not eq(nil)
    end

    it 'returns an error when the chargeback does not exist' do
      get "/api/v1/chargebacks/#{@chargeback.id + 999}"
      expect(response.status).to eq(404)
      expect(JSON(response.body)).to eq('error' => 'Not found.')
    end
  end

  describe 'PUT update' do
    before(:each) do
      create :chargeback
      sign_in_as create :staff, :admin
      @chargeback = Chargeback.first
    end

    it 'updates a chargeback', :show_in_doc do
      put "/api/v1/chargebacks/#{@chargeback.id}", hourly_price: '10'
      expect(response.status).to eq(204)
    end

    it 'returns an error when the chargeback does not exist' do
      put "/api/v1/chargebacks/#{@chargeback.id + 999}", hourly_price: '9'
      expect(response.status).to eq(404)
      expect(JSON(response.body)).to eq('error' => 'Not found.')
    end
  end

  describe 'POST create' do
    before(:each) do
      sign_in_as create :staff, :admin
    end

    it 'creates an chargeback', :show_in_doc do
      post '/api/v1/chargebacks/', hourly_price: '9'
      expect(response.body).to eq(Chargeback.first.to_json)
    end
  end

  describe 'DELETE destroy' do
    before :each do
      sign_in_as create :staff, :admin
      @chargeback = create :chargeback
    end

    it 'removes the chargeback', :show_in_doc do
      delete "/api/v1/chargebacks/#{@chargeback.id}"
      expect(response.status).to eq(204)
    end

    it 'returns an error when the chargeback does not exist' do
      delete "/api/v1/chargebacks/#{@chargeback.id + 999}"
      expect(response.status).to eq(404)
      expect(JSON(response.body)).to eq('error' => 'Not found.')
    end
  end
end

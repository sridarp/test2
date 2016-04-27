require 'rails_helper'

RSpec.describe 'Organizations' do
  let(:default_params) { { format: :json } }

  describe 'GET index' do
    before(:each) do
      create :organization
      create :organization
      @organizations = Organization.all
      sign_in_as create :staff, :admin
    end

    it 'returns a collection of all of the organizations', :show_in_doc do
      get '/api/v1/organizations'
      expect(response.body).to eq(@organizations.to_json)
    end

    it 'paginates the organizations' do
      get '/api/v1/organizations', page: 1, per_page: 1
      expect(json.length).to eq(1)
    end
  end

  describe 'GET show' do
    before(:each) do
      create :organization
      @organization = Organization.first
      sign_in_as create :staff, :admin
    end

    it 'returns an organization', :show_in_doc do
      get "/api/v1/organizations/#{@organization.id}"
      expect(response.body).to eq(@organization.to_json)
    end

    it 'returns an error when the organization does not exist' do
      get "/api/v1/organizations/#{@organization.id + 999}"
      expect(response.status).to eq(404)
      expect(JSON(response.body)).to eq('error' => 'Not found.')
    end
  end

  describe 'PUT update' do
    before(:each) do
      create :organization
      @organization = Organization.first
      sign_in_as create :staff, :admin
    end

    it 'updates an organization', :show_in_doc do
      put "/api/v1/organizations/#{@organization.id}", name: 'some different name'
      expect(response.status).to eq(204)
    end

    it 'returns an error when the organization does not exist' do
      put "/api/v1/organizations/#{@organization.id + 999}", name: 'some different name'
      expect(response.status).to eq(404)
      expect(JSON(response.body)).to eq('error' => 'Not found.')
    end
  end

  describe 'POST create' do
    before :each do
      sign_in_as create :staff, :admin
    end

    it 'creates an organization', :show_in_doc do
      post '/api/v1/organizations/', name: 'some name', img: 'img.png', description: 'best org ever'
      expect(response.body).to eq(Organization.first.to_json)
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @organization = create :organization
      sign_in_as create :staff, :admin
    end

    it 'removes the organization', :show_in_doc do
      delete "/api/v1/organizations/#{@organization.id}"
      expect(response.status).to eq(204)
    end

    it 'returns an error when the organization does not exist' do
      delete "/api/v1/organizations/#{@organization.id + 999}", name: 'some different name'
      expect(response.status).to eq(404)
      expect(JSON(response.body)).to eq('error' => 'Not found.')
    end
  end
end

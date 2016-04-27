require 'rails_helper'

RSpec.describe 'Sessions API' do
  let(:default_params) { { format: :json } }
  let(:password) { 'test1234' }
  let(:email) { 'foo@bar.com' }

  describe 'POST create' do
    before :each do
      @staff = create :staff, :admin, email: email, password: password, password_confirmation: password
    end

    it 'creates a session for valid users', :show_in_doc do
      post '/api/v1/staff/sign_in.json', staff: { email: email, password: password }
      expect(response).to be_success
    end

    it 'does not create a session for invalid users', :show_in_doc do
      post '/api/v1/staff/sign_in.json', staff: { email: email, password: 'invalidpassword' }
      expect(response).to be_unauthorized
    end

    it 'adds a new api_token' do
      post '/api/v1/staff/sign_in.json', staff: { email: email, password: password }
      expect(json.key?('api_token')).to be true
      expect(json['api_token'].length).to eq(32)
      api_token = ApiToken.find_by token: json['api_token']
      expect(api_token.staff_id).to eq @staff.id
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @staff = create :staff, :admin, email: email, password: password, password_confirmation: password
    end

    it 'ends a users session' do
      post '/api/v1/staff/sign_in.json', staff: { email: email, password: password }
      delete '/api/v1/staff/sign_out.json'
      expect(json).to eq({})
      expect(response).to be_success
    end

    it 'does not end null sessions', :show_in_doc do
      post '/api/v1/staff/sign_in.json', staff: { email: email, password: 'invalidpassword' }
      delete '/api/v1/staff/sign_out.json'
      expect(response).to be_unauthorized
    end

    it 'removes the api_token' do
      post '/api/v1/staff/sign_in.json', staff: { email: email, password: password }
      expect(json.key?('api_token')).to be true
      expect(json['api_token'].length).to eq(32)
      api_token = ApiToken.find_by token: json['api_token']
      expect(api_token.staff_id).to eq @staff.id
      delete '/api/v1/staff/sign_out.json', {}, 'Authorization' => "Jellyfish #{api_token.token}"
      expect(ApiToken.find_by(token: json['api_token'])).to be_nil
    end
  end
end

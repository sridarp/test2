require 'rails_helper'

describe ApplicationController do
  let(:default_params) { { format: :json } }

  controller do
    def index
      render nothing: true
    end
  end

  describe 'user authentication', type: :controller do
    it "returns a 401 if the user isn't logged in" do
      get :index

      expect(response).to be_unauthorized
    end

    it 'allows an access token sent as a request varible' do
      api_token = create(:api_token)
      create(:staff, api_tokens: [api_token])

      get :index, access_token: api_token.token

      expect(response).to be_successful
    end

    it 'allows an access token sent in the headers' do
      api_token = create(:api_token)
      create(:staff, api_tokens: [api_token])
      @request.headers['Authorization'] = "token #{api_token.token}"

      get :index

      expect(response).to be_successful
    end
  end
end

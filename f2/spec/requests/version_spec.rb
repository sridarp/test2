require 'rails_helper'

RSpec.describe 'Version API' do
  let(:default_params) { { format: :json } }
  let(:version) { create :version }

  describe 'GET show' do
    it 'returns the app version' do
      get version_path
      expect(response).to be_success
    end
  end
end

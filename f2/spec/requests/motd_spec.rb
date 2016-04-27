require 'rails_helper'

RSpec.describe 'MOTD API' do
  let(:default_params) { { format: :json } }
  let(:motd) { create :motd }

  describe 'GET show' do
    it 'returns a the MOTD for an admin' do
      sign_in_as create(:staff, :admin)

      get motd_path

      expect(response.body).to eq(Motd.first.to_json)
    end

    it 'returns a the MOTD for a user' do
      sign_in_as create(:staff, :user)

      get motd_path

      expect(response.body).to eq(Motd.first.to_json)
    end

    it 'returns a the MOTD for a guest' do
      get motd_path

      expect(response.body).to eq(Motd.first.to_json)
    end
  end

  describe 'POST create' do
    it 'allows creation of an MOTD for an admin' do
      sign_in_as create(:staff, :admin)

      post motd_path, message: 'This is a test MOTD'

      expect(response.body).to eq(Motd.first.to_json)
    end

    it 'prevents creation of an MOTD for a user' do
      sign_in_as create(:staff, :user)

      post motd_path, message: 'This is a test MOTD'

      expect(response.status).to eq(403)
    end

    it 'prevents creation of an MOTD for a guest' do
      post motd_path, message: 'This is a test MOTD'

      expect(response.status).to eq(401)
    end
  end

  describe 'PUT update' do
    before(:each) do
      @motd = Motd.first
    end

    it 'allows an admin to make updates' do
      sign_in_as create(:staff, :admin)

      put motd_path, message: 'This is an updated test MOTD'

      expect(response.status).to eq(204)
    end

    it 'prevents updates for a user' do
      sign_in_as create(:staff, :user)

      put motd_path, message: 'This is an updated test MOTD'

      expect(response.status).to eq(403)
    end

    it 'prevents updates for a guest' do
      put motd_path, message: 'This is an updated test MOTD'

      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE destroy' do
    it 'allows an admin to delete an MOTD' do
      sign_in_as create(:staff, :admin)

      delete motd_path

      expect(response.status).to eq(204)
    end

    it 'prevents deleting for a user' do
      sign_in_as create(:staff, :user)

      delete motd_path

      expect(response.status).to eq(403)
    end

    it 'prevents deleting for a guest' do
      delete motd_path

      expect(response.status).to eq(401)
    end
  end
end

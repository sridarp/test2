require 'rails_helper'

describe 'Role API' do
  describe 'GET index' do
    it 'returns all roles' do
      sign_in_as create(:staff)
      role = create(:role)

      get roles_path

      expect(response.body).to eq([role].to_json)
    end
  end

  describe 'POST create' do
    it 'creates a role' do
      sign_in_as create(:staff, :admin)

      expect do
        post roles_path, attributes_for(:role)
      end.to change { Role.count }.by(1)

      expect(response).to be_success
    end

    it 'requires an admin' do
      sign_in_as create(:staff)

      post roles_path, attributes_for(:role)

      expect(response.status).to eq 403
    end
  end

  describe 'PUT update' do
    it 'creates a role' do
      sign_in_as create(:staff, :admin)
      role = create(:role)

      put role_path(role), name: 'new name'

      expect(response).to be_success
      expect(role.reload.name).to eq 'new name'
    end

    it 'requires an admin' do
      sign_in_as create(:staff)
      role = create(:role)

      put role_path(role), name: 'new name'

      expect(response.status).to eq 403
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a role' do
      sign_in_as create(:staff, :admin)
      role = create(:role)

      delete role_path(role)

      expect(response).to be_success

      expect(Role).not_to exist(role.id)
    end

    it 'requires an admin' do
      sign_in_as create(:staff)
      role = create(:role)

      delete role_path(role)

      expect(response.status).to eq 403
    end
  end
end

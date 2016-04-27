require 'rails_helper'

RSpec.describe 'Memberships API' do
  let(:default_params) { { format: :json } }

  describe 'GET index' do
    it 'lists all available on a project' do
      sign_in_as create :staff, :admin
      # CREATE TWO GROUPS
      group1 = create(:group)
      group2 = create(:group)

      # CREATE TWO ROLES
      role1 = create(:role)
      role2 = create(:role)

      # CREATE A PROJECT
      project = create(:project)

      # ASSOCIATE GROUPS WITH ROLES AGAINST PROJECT
      post project_memberships_path(project, group_id: group1.id, role_id: role1.id)
      post project_memberships_path(project, group_id: group2.id, role_id: role2.id)

      project.reload

      # REQUEST LIST OF MEMEBERSHIPS
      get "/api/v1/projects/#{project.id}/memberships"

      # VERIFY MEMEBERSHIP COUNT RETURNED FROM INDEX
      expect(JSON.parse(response.body).count).to eq(2)
    end
  end

  describe 'POST create' do
    it 'associates a group with a role to a project' do
      sign_in_as create :staff, :admin
      group = create(:group)
      role = create(:role)
      project = create(:project)

      post project_memberships_path(project, group_id: group.id, role_id: role.id)

      project.reload
      expect(response).to be_successful
      expect(project.groups).to include(group)
    end
  end

  describe 'DELETE destroy' do
    it 'removes a group and role from a project' do
      sign_in_as create :staff, :admin
      group = create(:group)
      project = create(:project, groups: [group])

      membership = project.memberships.first

      delete membership_path(membership.id)

      project.reload
      expect(response).to be_successful
      expect(project.groups).not_to include(group)
    end

    it 'raises 404 when the membership does not exist' do
      sign_in_as create :staff, :admin
      delete membership_path(9999)
      expect(response).to be_not_found
    end
  end
end

require 'rails_helper'

describe 'StaffPermissions API' do
  describe 'GET show' do
    it 'returns all user permissions by project id' do
      staff = create :staff
      project = create :project

      group_a = create :group, staff: [staff]
      role_a = create :role, permissions: { projects: ['read'], approvals: ['write'] }

      group_b = create :group, staff: [staff]
      role_b = create :role, permissions: { projects: ['write'], approvals: ['read'] }

      project.memberships.create group: group_a, role: role_a
      project.memberships.create group: group_b, role: role_b

      sign_in_as staff
      get staff_permission_path(staff, project, format: :json)

      expect(json).to have_key 'projects'
      expect(json).to have_key 'approvals'
      expect(json['projects']).to contain_exactly 'read', 'write'
      expect(json['approvals']).to contain_exactly 'read', 'write'
    end
  end
end

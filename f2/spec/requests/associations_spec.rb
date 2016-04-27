require 'spec_helper'

describe 'Associations API' do
  describe 'POST create' do
    it 'adds a user to a group' do
      sign_in_as create(:staff, :admin)
      group = create(:group)
      staff = create(:staff)

      post "/api/v1/groups/#{group.id}/staff/#{staff.id}"

      expect(response).to be_success
      expect(group.reload.staff).to eq [staff]
    end

    it 'increments the staff_count counter cache' do
      sign_in_as create(:staff, :admin)
      group = create(:group)
      staff = create(:staff)

      post "/api/v1/groups/#{group.id}/staff/#{staff.id}"

      expect(response).to be_success
      expect(group.reload.staff_count).to eq 1
    end
  end

  describe 'DELETE destroy' do
    it 'removes a staff from a group' do
      sign_in_as create(:staff, :admin)
      staff = create(:staff)
      group = create(:group, groups_staff: [create(:groups_staff, staff: staff)])

      delete "/api/v1/groups/#{group.id}/staff/#{staff.id}"

      expect(response).to be_success
      expect(group.reload.staff).to eq []
    end

    it 'decrements the staff_count counter cache' do
      sign_in_as create(:staff, :admin)
      staff = create(:staff)
      group = create(:group)

      post "/api/v1/groups/#{group.id}/staff/#{staff.id}"

      expect(group.reload.staff_count).to eq 1

      delete "/api/v1/groups/#{group.id}/staff/#{staff.id}"

      expect(response).to be_success
      expect(group.reload.staff_count).to eq 0
    end

    it '404s if the staff was not on the group' do
      sign_in_as create(:staff, :admin)
      staff = create(:staff)
      group = create(:group)

      delete "/api/v1/groups/#{group.id}/staff/#{staff.id}"

      expect(response).to be_not_found
    end
  end
end

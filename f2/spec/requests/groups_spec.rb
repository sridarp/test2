require 'rails_helper'

RSpec.describe 'Groups API' do
  describe 'GET show' do
    it 'returns a group', :show_in_doc do
      sign_in_as create :staff, :admin
      group = create(:group)

      get group_path(group, format: :json)

      expect(response.body).to match_serialized_json(group)
    end
  end

  describe 'GET index' do
    it 'returns a list of groups' do
      sign_in_as create :staff, :admin
      groups = create_list(:group, 2)

      get groups_path(format: :json)

      expect(response.body).to match_serialized_json(groups)
    end
  end

  describe 'POST create' do
    it 'creates a group' do
      sign_in_as create :staff, :admin
      group_attributes = attributes_for(:group)

      post groups_path(format: :json), group_attributes

      group = Group.last
      expect(response.body).to match_serialized_json(group)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a group' do
      sign_in_as create :staff, :admin
      group = create(:group)

      delete group_path(group, format: :json)

      expect(response).to be_successful
      expect(Group.find_by_id(group.id)).to be_nil
    end
  end
end

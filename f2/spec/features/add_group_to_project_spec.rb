# require 'rails_helper'
#
# feature 'Add group to project', js: true do
#   scenario 'specify group access to a project by giving it a role' do
#     pending
#     project = create(:project)
#     role = create(:role)
#     staff = create(:staff, :admin)
#     # Adding a group to a project in the UI seems untestable.
#     group = create(:group, projects: [project], staff: [staff])
#
#     expect(Membership.last.role_id).to be_nil
#
#     login_as staff
#
#     visit "/project/#{project.id}"
#
#     within('#groups-list') do
#       expect(page).to have_content(group.name)
#       expect(page).to have_selector("#group-#{group.id}")
#     end
#
#     within("#group-#{group.id}-role") do
#       find('.selectize-input').click
#       find('div.option', text: role.name).click
#     end
#
#     sleep 1
#     expect(Membership.last.role).to eq role
#   end
# end

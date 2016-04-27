# require 'rails_helper'
#
# feature 'Project creation' do
#   scenario 'staff creates a project', :js do
#     pending
#     group = create(:group)
#     staff = create(:staff, :admin, groups: [group])
#     login_as(staff)
#     visit '/project/new'
#
#     fill_in 'Name', with: 'Project Jellyfish'
#     fill_in 'Icon', with: 'http://www.example.com/image.png'
#     fill_in 'Budget', with: '$100,000'
#     fill_in 'Start Date', with: '2020-01-01'
#     fill_in 'End Date', with: '2020-12-01'
#     select_group(group)
#     find('a', text: 'CREATE').click
#
#     expect(page).to have_content('Project created successfully.')
#   end
#
#   def select_group(group)
#     fill_in 'group_search_value', with: group.name
#     find('.angucomplete-title', text: group.name).click
#   end
# end

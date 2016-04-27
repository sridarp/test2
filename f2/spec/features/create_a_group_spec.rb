# require 'rails_helper'
#
# feature 'Group creation' do
#   scenario 'admin creates a group', :js do
#     pending
#     login_as(create(:staff, :admin))
#     member_staff = create(:staff)
#     group = build(:group)
#     visit '/admin/groups/list'
#     click_on('Add New Group')
#
#     fill_in('Group Name', with: group.name)
#     fill_in('Group Description', with: group.description)
#     within('#users') do
#       find('.ui-select-search').click
#       find(:xpath, "//span[contains(text(),'#{member_staff.email}')]").click
#     end
#     click_on 'CREATE NEW GROUP'
#
#     expect(page).to have_css('.product-title', text: group.name)
#   end
# end

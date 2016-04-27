# require 'rails_helper'
#
# feature 'Staff signs in' do
#   scenario 'normal staff successfully signs in with email and password', :js do
#     staff = create(:staff)
#
#     visit root_path
#     fill_in 'email', with: staff.email
#     fill_in 'password', with: staff.password
#     click_on 'Login'
#
#     expect(page).to have_content('WELCOME')
#   end
#
#   feature 'using OmniAuth modules' do
#     scenario 'normal staff successfully signs in with email using OmniAuth developer strategy', :js do
#       visit '/api/v1/staff/auth/developer'
#       staff = create(:staff)
#
#       fill_in 'name', with: staff.first_name
#       fill_in 'email', with: staff.email
#       click_button 'Sign In'
#
#       # I'm not sure why this takes so long, but it fixes the error "timeout while waiting for angular"
#       Capybara.default_wait_time = 10
#
#       expect(page).to have_content("#{staff.first_name} #{staff.last_name}")
#     end
#
#     scenario 'normal staff fails signing in with email using OmniAuth developer strategy', :js do
#       visit '/api/v1/staff/auth/developer'
#
#       fill_in 'email', with: 'user@nonexistant.com'
#       click_button 'Sign In'
#
#       expect(page).to have_content('{"error":"Not found."}')
#     end
#   end
# end

# require 'rails_helper'
#
# feature 'Stack wizard' do
#   scenario 'user edits the Wizard', :js do
#     pending
#     staff = create(:staff, :admin)
#     login_as(staff)
#
#     visit '/admin/wizard-questions'
#
#     fill_in 'Question', with: 'What programming language will be used?'
#     fill_in 'Answer', with: 'PHP'
#     fill_in 'Tags to Add', with: 'PHP'
#     fill_in 'Tags to Remove', with: 'Ruby'
#
#     find('a', text: 'Save Question and Add Another').click
#
#     visit '/admin/wizard-questions'
#
#     expect(page.find('#question_0').value).to eq 'What programming language will be used?'
#     expect(page.find('#answer_0').value).to eq 'PHP'
#     expect(page.find('#tags_to_add_0').value).to eq 'PHP'
#     expect(page.find('#tags_to_remove_0').value).to eq 'Ruby'
#   end
# end

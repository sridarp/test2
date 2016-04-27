# require 'rails_helper'
#
# feature 'Stack wizard' do
#   scenario 'user runs the Wizard', :js do
#     pending
#     staff = create(:staff, :admin)
#     login_as(staff)
#     questions = create_pair(:wizard_question, :with_answers)
#     project = create(:project)
#
#     visit "/project/#{project.id}/wizard"
#
#     expected_tags = questions.inject([]) do |tags, question|
#       expect(page).to have_content(question.text)
#
#       answer = question.wizard_answers.first
#
#       choose answer.text
#       update_tags(tags, answer)
#     end
#
#     expected_tags = expected_tags.map { |t| "tags=#{t}" }.join('&')
#
#     expect(page).to have_content('COMPARE')
#     expect(URI(current_url).query).to eq expected_tags
#   end
#
#   def update_tags(tags, answer)
#     tags += answer.tags_to_add
#     tags -= answer.tags_to_remove
#     tags.uniq
#   end
# end

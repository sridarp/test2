require 'rails_helper'

describe 'WizardQuestions API' do
  describe 'GET show' do
    it 'returns the wizard question' do
      sign_in_as create :staff, :admin
      answer = create(
        :wizard_answer,
        text: 'PHP',
        tags_to_add: %w(PHP Linux),
        tags_to_remove: %w(Windows Java Ruby dotNet)
      )
      question = create(
        :wizard_question,
        text: 'What programming language will be used?',
        wizard_answers: [answer]
      )

      get "/api/v1/wizard_questions/#{question.id}", includes: %w(wizard_answers)

      expect(json).to include({ text: 'What programming language will be used?' }.deep_stringify_keys)
    end
  end

  describe 'GET index' do
    it 'returns the all the questions' do
      questions = create_list(:wizard_question, 2)
      sign_in_as create :staff, :admin

      get '/api/v1/wizard_questions', includes: %w(wizard_answers)

      questions.each_with_index do |question, index|
        expect(json[index]['id']).to eq question.id
      end
    end
  end

  describe 'GET first' do
    it 'returns the first question' do
      first_question = create(:wizard_question)
      _second_question = create(:wizard_question)
      sign_in_as create :staff, :admin

      get '/api/v1/wizard_questions/first', includes: %w(wizard_answers)

      expect(json['id']).to eq first_question.id
    end
  end

  describe 'POST create' do
    it 'creates a wizard question' do
      sign_in_as create :staff, :admin

      post '/api/v1/wizard_questions', text: 'Test question?'

      last_wizard_question = WizardQuestion.last
      expect(last_wizard_question.text).to eq('Test question?')
    end
  end

  describe 'PUT update' do
    it 'upate a wizard question' do
      sign_in_as create :staff, :admin
      wizard_question = create(:wizard_question)

      data = {
        text: 'Updated question?',
        wizard_answers: [
          text: 'test',
          tags_to_remove: %w(tag1 tag2),
          tags_to_add: %w(tag1 tag2)
        ]
      }

      include_data = {
        text: 'test',
        tags_to_remove: %w(tag1 tag2),
        tags_to_add: %w(tag1 tag2)
      }

      put "/api/v1/wizard_questions/#{wizard_question.id}", data

      last_wizard_question = WizardQuestion.last
      expect(last_wizard_question.text).to eq('Updated question?')
      expect(last_wizard_question.wizard_answers.last.attributes).to include(include_data.stringify_keys)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a wizard question' do
      sign_in_as create :staff, :admin
      wizard_question = create(:wizard_question)

      delete "/api/v1/wizard_questions/#{wizard_question.id}"

      expect(response).to be_successful
      expect(WizardQuestion.find_by_id(wizard_question.id)).to be_nil
    end
  end
end

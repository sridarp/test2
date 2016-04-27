require 'rails_helper'

RSpec.describe 'Projects API' do
  let(:default_params) { { format: :json } }

  let(:question) { 'Why did the chicken cross the road?' }
  let(:answer) { 'To get to the other side.' }
  let(:project_name) { 'To get to the other side.' }
  let(:question_model) { create :project_question, question: question, position: 0 }

  describe 'GET index' do
    before :each do
      @project = create :project
      @project2 = create :project
    end

    it 'returns a collection of all projects', :show_in_doc do
      sign_in_as create :staff, :admin
      create(:staff).groups << Group.new(projects: [@project])

      get '/api/v1/projects'

      expect(json.length).to eq(2)
    end

    it 'paginates the projects' do
      sign_in_as create :staff, :admin
      get '/api/v1/projects', page: 1, per_page: 1
      expect(json.length).to eq(1)
    end

    it "returns a 401 error if the user isn't logged in" do
      get '/api/v1/projects'
      expect(response).to be_unauthorized
    end
  end

  describe 'GET show' do
    before :each do
      @project = create :project
    end

    it 'retrieves project by id' do
      sign_in_as create :staff, :admin
      get "/api/v1/projects/#{@project.id}"
      expect(json['name']).to eq(@project.name)
    end

    it 'returns an error when the project does not exist' do
      sign_in_as create :staff, :admin
      get "/api/v1/projects/#{@project.id + 999}"
      expect(response.status).to eq(404)
      expect(json).to eq('error' => 'Not found.')
    end
  end

  describe 'POST create' do
    it 'creates a new project record for admin' do
      sign_in_as create :staff, :admin
      project_data = attributes_for(:project)

      post '/api/v1/projects', project_data

      expect(json['name']).to eq(project_data[:name])
    end

    it 'creates a new project record w/ project answers for admin', :show_in_doc do
      sign_in_as create :staff, :admin
      project_data = attributes_for(:project, answers: [{ name: question_model.id, value: answer, value_type: 'string' }])

      post '/api/v1/projects', project_data.merge(includes: %w(answers))

      expect(json['answers'][0]['name']).to eq(question_model.id.to_s)
    end

    it 'fails to create a new project without a group for staff' do
      pending 'A user should not be telling the system how to give them access to things'
      sign_in_as create(:staff, groups: [create(:group)])
      project_data = attributes_for(:project, group_ids: [])

      post '/api/v1/projects', project_data

      expect(response.status).to eq(422)
    end

    it 'fails to create a new project without a group for staff' do
      group = create(:group)
      sign_in_as create(:staff, groups: [group])
      project_data = attributes_for(:project, group_ids: [group.id])

      post '/api/v1/projects', project_data

      expect(response).to be_success
    end

    it "returns a 401 error if the user isn't logged in" do
      project_data = attributes_for(:project, project_answers: [{ project_question_id: question_model.id, answer: answer }])
      post '/api/v1/projects', project_data.merge(includes: %w(project_answers))
      expect(response).to be_unauthorized
    end
  end

  describe 'PUT update' do
    before :each do
      @project = create :project
    end

    it 'changes existing project' do
      sign_in_as create :staff, :admin
      put "/api/v1/projects/#{@project.id}", name: 'Updated', budget: 1.99
      expect(response.status).to eq(204)
    end

    it 'updates a project record w/ project answers', :show_in_doc do
      sign_in_as create :staff, :admin

      project_data = attributes_for(:project, answers: [{ name: 'foo', value: answer, value_type: 'string' }])
      put "/api/v1/projects/#{@project.id}", project_data
      @project.reload
      expect(@project.answers.length).to eq(1)
    end

    it 'returns an error when the project does not exist' do
      sign_in_as create :staff, :admin
      put "/api/v1/projects/#{@project.id + 999}", attributes_for(:project)
      expect(response.status).to eq(404)
      expect(json).to eq('error' => 'Not found.')
    end

    it "returns a 401 error if the user isn't logged in" do
      put "/api/v1/projects/#{@project.id}", name: 'Updated', budget: 1.99
      expect(response).to be_unauthorized
    end
  end
end

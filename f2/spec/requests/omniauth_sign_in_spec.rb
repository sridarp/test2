require 'rails_helper'

RSpec.describe 'OmniAuth sign in', type: :rack_test do
  let(:app) do
    Rack::Builder.new do |b|
      b.use Rack::Session::Cookie, secret: 'abc123'
      b.use OmniAuth::Strategies::Developer, path_prefix: '/api/v1/staff/auth'
      b.run -> (_env) { [200, {}, ['Not Found']] }
    end.to_app
  end

  context 'request phase' do
    before(:each) { get '/api/v1/staff/auth/developer' }

    it 'displays a form' do
      expect(last_response.status).to eq(200)
      expect(last_response.body).to be_include('<form')
    end

    it 'has the callback as the action for the form' do
      expect(last_response.body).to be_include("action='/api/v1/staff/auth/developer/callback'")
    end

    it 'has a text field for each of the fields' do
      expect(last_response.body.scan('<input').size).to eq(2)
    end
  end

  context 'callback phase' do
    let(:auth_hash) { last_request.env['omniauth.auth'] }

    context 'with custom options' do
      let(:app) do
        Rack::Builder.new do |b|
          b.use Rack::Session::Cookie, secret: 'abc123'
          b.use OmniAuth::Strategies::Developer, path_prefix: '/api/v1/staff/auth', fields: [:email, :password], uid_field: :email
          b.run -> (_env) { [200, {}, ['Not Found']] }
        end.to_app
      end

      before do
        @options = { uid_fields: :email, fields: [:email, :password] }
        post '/api/v1/staff/auth/developer/callback', email: 'user@example.com', password: '1234'
      end

      it 'sets info fields properly' do
        expect(auth_hash.info.email).to eq('user@example.com')
      end

      it 'sets the uid properly' do
        expect(auth_hash.uid).to eq('user@example.com')
      end
    end
  end

  context 'mock auth' do
    before do
      OmniAuth.config.add_mock(:developer, uid: '12345', info: { name: 'Example User', email: 'user@example.com' })
    end

    it 'default is AuthHash' do
      OmniAuth.configure do |config|
        expect(config.mock_auth[:default]).to be_kind_of(OmniAuth::AuthHash)
      end
    end

    it 'developer is AuthHash' do
      OmniAuth.configure do |config|
        expect(config.mock_auth[:developer]).to be_kind_of(OmniAuth::AuthHash)
      end
    end

    it 'sets developer attributes' do
      OmniAuth.configure do |config|
        expect(config.mock_auth[:developer].uid).to eq('12345')
        expect(config.mock_auth[:developer].info.name).to eq('Example User')
        expect(config.mock_auth[:developer].info.email).to eq('user@example.com')
      end
    end
  end
end

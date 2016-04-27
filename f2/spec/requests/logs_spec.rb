require 'rails_helper'

describe 'Logs API' do
  describe 'GET index' do
    before :each do
      sign_in_as create :staff, :admin
      @service = create :service
      @log1 = create(
        :service_log,
        message: 'This is a test log message #1',
        loggable: @service
      )
      @log2 = create(
        :service_log,
        message: 'This is a test log message #2',
        loggable: @service
      )
    end

    it 'returns all logs for the service' do
      get "/api/v1/logs/Service/#{@service.id}"

      expect(json[0]['id']).to eq @log1.id
      expect(json[1]['id']).to eq @log2.id
    end
  end
end

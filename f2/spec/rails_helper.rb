ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'pry'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

# module Features
#   include Capybara::Angular::DSL
# end

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.include ActiveModelSerializersHelper, type: :request
  config.include BackgroundJobs
  config.include Features, type: :feature
  config.before :suite do
    Warden.test_mode!
  end

  config.include Shoulda::Matchers
  # Capybara.javascript_driver = :poltergeist
end

Jellyfish Module Setup (Steps 1-7)
============

This guide explains how to create a module that can be used with <a href="https://github.com/projectjellyfish/api" target="_blank">Project Jellyfish</a>.

### Step 1: Create Empty Module

Modules in Jellyfish are implemented with gemified <a href="http://guides.rubyonrails.org/engines.html" target="_blank">Rails engines</a>.

To create a new module named `jellyfish_logger` run:

```shell
$ rails plugin new jellyfish_logger --dummy-path=spec/dummy --skip-test-unit --skip-bundle --mountable
```

Jellyfish uses <a href="http://rspec.info/" target="_blank">rspec</a>, so skip test-unit and auto bundle. See a good discussion of mountable 
engines <a href="http://stackoverflow.com/questions/6118905/rails-3-1-engine-vs-mountable-app#answer-6833288" target="_blank">here</a>.

### Step 2: Update Gemspec and Gemfile

__Populate gemspec__

Start by specifying a homepage, summary and description in Gemspec:
```shell
s.homepage    = "www.projectjellyfish.org"
s.summary     = "Jellyfish Logger Module "
s.description = "A module that adds log support to Jellyfish API"
```

__Add dependencies__

Specify unversioned dependencies for rails and dotenv and replace sqlite3 with pg in Gemspec:
```shell
s.add_dependency "rails"
s.add_dependency "dotenv-rails" # to use env vars from jellyfish api
s.add_dependency 'pg' # to use jellyfish db
```

And add these dev and test dependencies to your Gemfile.
```shell
# DEV + TEST
group :development, :test do
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'rubocop'
  gem 'pry'
end
```
### Step 3: Setup Rakefile

Modify Rakefile to look like this:
```shell
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

require 'rspec/core'
require 'rspec/core/rake_task'
desc 'Run all specs in spec directory'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec
```
The last block makes `rspec` executable via `rake`.

#### Step 4: Setup Engine

Modify `lib/jellyfish_logger/engine.rb`  to autoload `lib` dir:
```ruby
module JellyfishLogger
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishLogger
    config.autoload_paths += %W(#{config.root}/lib)
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
```
See <a href="http://apidock.com/rails/Rails/Engine/isolate_namespace/class#1438-isolate-namespace-description-with-example" target="_blank">here</a> for the reason why `isolate_namespace` is used.

### Step 5: Setup RSpec

__Add Spec Helpers__

Run `rails generate rspec:install` to add the following skeleton files:
- `.rspec`
- `spec/spec_helper.rb`
- `spec/rails_helper.rb`

Modify `.rspec` to run helpers before specs and format output:
```
--color
--format documentation
--require rails_helper
```

And update `spec/rails_helper.rb` to:

```ruby
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'

# Loads Spec Support Files
Dir[Rails.root.join('../support/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
```
This mounts `jellyfish_logger` on the test application in `spec/dummy`.

__Setup Spec Database__

Update `spec/dummy/config/database.yml` to use PostgreSQL:

```yaml
development: &default
  adapter: postgresql
  database: jellyfish_logger_development
  encoding: utf8
  host: localhost
  min_messages: warning
  pool: 2
  timeout: 5000

test:
  <<: *default
  database: jellyfish_logger_test

production:
  <<: *default
  database: jellyfish_logger_production
```

And add `spec/support/database_cleaner.rb` to clean up after tests:

```ruby
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :integration) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```
This is included by `Dir[Rails.root.join('../support/*.rb')].each { |f| require f }` in `spec/rails_helper.rb`.

__Add Spec Routes__

Include default Rails WelcomeController routes in `spec/dummy/config/routes.rb`:
```ruby
Rails.application.routes.draw do
  get '/rails/info/properties' => "rails/info#properties"
  get '/rails/info/routes'     => "rails/info#routes"
  get '/rails/info'            => "rails/info#index"
  get '/'                      => "rails/welcome#index"
  mount JellyfishLogger::Engine => "/jellyfish_logger"
end
```
They <a href="http://stackoverflow.com/questions/17964830/where-is-the-default-welcome-aboard-page-located-in-my-app" target="_blank">are only loaded in development</a> and need to be available in test.

__Setup Dotenv__

By default, the `spec/dummy` application will not load Dotenv in test, so add the following lines to `spec/dummy/config/application.rb`:
```ruby
...
Bundler.require(*Rails.groups)
require "jellyfish_audit"

require "dotenv-rails"
Dotenv::Railtie.load

module Dummy
  class Application < Rails::Application
...
```

### Step 6: Verify Rake

First install gem dependencies:
```
$ bundle
```

Then create development and test databases for module:
```
$ rake db:create
```
These are required for specs and running the dummy application in the development.

And verify `rake` is setup:
```
$ rake
...
No examples found.

Finished in 0.00027 seconds (files took 1 second to load)
0 examples, 0 failures
```

### Step 7: Setup Git

__Initialize Repo__

Initialize git in your module:
```
git init
```

Replace `.gitignore` with the following:
```
# Ignore spec database.
spec/dummy/db

# Ignore log and tmp files.
log
tmp
spec/dummy/log
spec/dummy/tmp


# Ignore RubyMine files
.idea

# Ignore dotenv file
.env

# Ignore Gemfile lock
Gemfile.lock
```

Make your first commit:
```
git add .
git commit -m 'initial commit'
```

If you've created a repo on GitHub to host your module, then specify it as your origin:
```
git remote add origin https://github.com/projectjellyfish/jellyfish_logger.git
```

### (Optional) Step 8: Add Module Functionality

This section is optional and is on how to add functionality to your module.
You can directly proceed to Step 9 to load your module from Jellyfish API.

This section walks through how to create a client that persists to a filesystem or database from a Jellyfish module.

It assumes that you have an empty module setup with the above instructions (Steps 1 through 7).

__Create Client__

Add `lib/jellyfish_logger/client.rb` to module:

```ruby
require 'action_controller/log_subscriber'

module JellyfishLogger
  class Client < ActionController::LogSubscriber
    def process_action(event)
      extract_payload(event)
      log_payload
    end

    private

    def extract_payload(event)
      @payload = event.payload
      @controller = @payload[:controller]
      @action = @payload[:action]
      @params = @payload[:params]
      @format = @payload[:format]
      @method = @payload[:method]
      @path = @payload[:path]
    end

    def log_payload
      Rails.logger.info('Controller: ' + @controller)
      Rails.logger.info('Method: ' + @method)
      Rails.logger.info('Action: ' + @action)
      Rails.logger.info('Format: ' + @format.to_s)
      Rails.logger.info('Path: ' + @path)
      Rails.logger.info('Params: ' + @params.to_s)
    end
  end
end
```

Then add `config/initializers/default.rb`:
```
JellyfishLogger::Client.attach_to :action_controller
```
to attach the client to any controller in the parent app which extends ActionController.

See [here](http://rubyjunky.com/cleaning-up-rails-4-production-logging.html) for an excellent discussion on the different ways to extend the default Rails logger.

__Persist to Filesystem__

Add methods `prepare_content` and `write_to_file` to `lib/jellyfish_logger/client.db` and call them from the `process_action` callback:
```ruby
def process_action(event)
  extract_payload(event)
  log_payload
  prepare_content
  write_to_file if ENV['LOG_TO_FILE'] == 'true'
end

private

def write_to_file
  path = Rails.root.to_s + '/log/audit.txt'
  Rails.logger.info('START LOGGING TO: ' + path)
  File.open(path, 'a') do |f|
    f.puts(@content)
  end
  Rails.logger.info('END LOGGING TO: ' + path)
end

def prepare_content
  content = []
  content << 'Controller: ' + @controller
  content << 'Method: ' + @method
  content << 'Action: ' + @action
  content << 'Format: ' + @format.to_s
  content << 'Params: ' + @params.to_s
  @content = content.map { |ln| "#{ln}\n" }.join
end
```

Then add `spec/dummy/.env`:
```
LOG_TO_FILE = true
```
which turns on logging in the `spec/dummy` application. The `write_to_file` `path` can be set to anywhere write access is permitted. When deployed with Jellyfish, this module will output to `log/audit.txt` in the parent apps root dir.

__Persist to Database__

Create `event` model with rails:
```shell

# use rails generator
rails g model event --no-test-framework
      invoke  active_record
      create    db/migrate/20150507193348_create_jellyfish_logger_events.rb
      create    app/models/jellyfish_logger/event.rb
```

And modify `20150507193348_create_jellyfish_logger_events.rb` as follows:
```ruby
class CreateJellyfishLoggerEvents < ActiveRecord::Migration
  def change
    create_table :jellyfish_logger_events do |t|
      t.text :controller
      t.text :method
      t.text :action
      t.text :format
      t.text :path
      t.text :params
      t.timestamps null: false
    end
  end
end
```

Then run `event` migrations:
```shell
rake db:migrate
== 20150507193348 CreateJellyfishLoggerEvents: migrating =======================
-- create_table(:jellyfish_logger_events)
   -> 0.0108s
== 20150507193348 CreateJellyfishLoggerEvents: migrated (0.0109s) ==============
```
which also prepares the module's database for testing.

<table><tbody><tr><td>
To add migrations from a module to Jellyfish API, run the following <b>inside</b> Jellyfish API:<br>
<pre># copy migrations from jellyfish_logger module to jellyfish
rake jellyfish_logger:install:migrations
Copied migration 20150507193348_create_jellyfish_logger_events.jellyfish_logger.rb from jellyfish_logger

# add jellyfish_logger models to jellyfish schema
rake db:migrate
== 20150507193348 CreateJellyfishLoggerEvents: migrating =======================
-- create_table(:jellyfish_logger_events)
   -> 0.0108s
== 20150507193348 CreateJellyfishLoggerEvents: migrated (0.0109s) ==============</pre></td></tr></tbody></table>

Add method `write_to_db` to `lib/jellyfish_logger/client.db` and call it from the `process_action` callback:
```ruby
def process_action(event)
  extract_payload(event)
  log_payload
  write_to_db
end

private

def write_to_db
  event_params = { controller: @controller, method: @method, action: @action, format: @format, path: @path, params: @params }
  e = Event.new event_params
  e.save
end
```

Navigating to `spec/dummy` and running `rails s` should start adding records to the `jellyfish_audit_events` table:
![image](https://cloud.githubusercontent.com/assets/9356425/7540072/415de952-f571-11e4-8651-0e7ff1a94e19.png)

Here is an example controller spec to verify events are being persisted:
```ruby
require 'rails_helper'

module JellyfishLogger
  RSpec.describe 'Jellyfish Logger Spec', type: :request do
    it 'logs an event on the welcome controller', type: :request do
      get '/'
      expect(Event.last.controller).to eq('Rails::WelcomeController')
      expect(Event.last.method).to eq('GET')
      expect(Event.last.action).to eq('index')
      expect(Event.last.format).to eq('html')
      expect(Event.last.path).to eq('/')
      expect(Event.last.params).to eq('{"controller"=>"rails/welcome", "action"=>"index"}')
    end
  end
end
```

### Step 9: Load Module

You can load `jellyfish_logger` from Jellyfish API by specifying its path in the parent app's Gemfile:
```
gem 'jellyfish_logger', path: '../jellyfish_logger'
```

Alternatively, you can load your module in a parent app's Gemfile from GitHub as follows:
```
gem 'jellyfish_logger', git: 'git://github.com/projectjellyfish/jellyfish_logger.git
```

See [here](http://guides.rubygems.org/publishing) for instructions on how to make your module accessible from 
RubyGems.org - not required, but nice to have.
